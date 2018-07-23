class Order < ApplicationRecord
  after_create :get_cost
  belongs_to :user
  validates :quantity, numericality: { greater_than: 0 }
  validates :cost, numericality: { greater_than: 0, less_than: 10000000 }, allow_nil: true
  validates :order_type, presence: true
  validates :flu_population_rate, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}

  public
    #process the order. It could be buy or sell
    def process
      #get cost of order
      if self.order_type == "buy"
        return false unless buy_process
        self.update_attributes(isDone: true)
      elsif self.order_type == "sell"
        sell_process
        self.update_attributes(isDone: true)
      else
	raise "Invalid order_type of order record!"
      end
    end
  
    def does_user_has_enough_shares?
      self.security_ids.each do |security_id|
        quantity_user_has = LineSecurity.find_by(user_id: self.user_id, security_id: security_id).quantity 
        if(quantity_user_has < self.quantity)
          return false
        end
      end 
      return true
    end
  
  private
    def get_cost
      cost = 0
      if(self.order_type == "buy")
	cost = MarketMaker.get_cost(self.date_market, self.security_group_ids, self.quantity)
      elsif(self.order_type == "sell")
	cost = MarketMaker.get_cost(self.date_market, self.security_group_ids, -self.quantity)
      end
      update_columns(cost: cost)
    end   
 
    #update user's money and shares
    def buy_process
      user_current_money = User.find(self.user_id).money
      #check payableness
      return false if user_current_money < self.cost
      #update user's money and security_group's share quantity which has been sold so far
      User.transaction do
        SecurityGroup.transaction do
          User.find(self.user_id).update_attributes(money: user_current_money - self.cost)
	  self.security_group_ids.each do |i|
	    current_security_group_shares = SecurityGroup.find(i).shares
            LineShare.create!( 
	      user_id: self.user_id, 
	      flu_population_rate: self.flu_population_rate, 
	      building_num: SecurityGroup.find(i).building_num,
	      quantity: self.quantity,
	      date_market: self.date_market,
	      security_group_id: i)
	    SecurityGroup.find(i).update_attributes(
              shares: self.quantity + current_security_group_shares)
	  end
        end
      end
    end
   
    def sell_process
      user_current_money = User.find(self.user_id).money
      #update user's money and security_group's share quantity which has been sold so far
      User.transaction do
        SecurityGroup.transaction do
          User.find(self.user_id).update_attributes(money: user_current_money + self.cost)
          self.security_group_ids.each do |i|
	    line_share = LineShare.find_by(
	      user_id: self.user_id,
	      available: true,
	      security_group_id: i
            )
	    quantity_user_has = line_share.quantity
	    #decrease the quantity of line_share
	    line_share.update_attributes!(
	        quantity: quantity_user_has - self.quantity)
	    
	    #if line_share quantity becomes 0, delete the line_share
	    if(line_share.quantity == 0)
	      line_share.delete
	    end
	    
	    security_group = SecurityGroup.find(i)
            security_group.update_attributes(
	        shares: security_group.shares - self.quantity)
          end
        end
      end

    end
end
