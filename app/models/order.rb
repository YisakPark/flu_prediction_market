class Order < ApplicationRecord
  after_save :update_cost
  belongs_to :user
  validates :quantity, numericality: { greater_than: 0 }
  validates :cost, numericality: { greater_than: 0, less_than: 10000000 }, allow_nil: true
  validates :order_type, presence: true

  public
    #process the order. It could be buy or sell
    def process
      #get cost of order
      cost = Security.get_cost(self.building_nums, self.quantity)
      if self.order_type == "buy"
        return false unless buy_process cost
        self.update_attributes(isDone: true)
      else
        sell_process cost
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
    def update_cost
      if(self.order_type == "buy")
        cost = Security.get_cost(self.security_ids, self.quantity)
      elsif(self.order_type == "sell")
        cost = Security.get_cost(self.security_ids, -self.quantity)
      end
      update_columns(cost: cost)
    end   
 
    def buy_process cost_to_pay
      user_current_money = User.find(self.user_id).money
      security_current_quantity = Security.find(self.security_id).quantity
      #check payableness
      return false if user_current_money < cost_to_pay
      #update user's money and security's quantity which has been sold so far
      User.transaction do
        Security.transaction do
          User.find(self.user_id).update_attributes(money: user_current_money - cost_to_pay)
          LineSecurity.create( user_id: self.user_id, security_id: self.security_id, quantity: self.quantity)
        end
      end
    end
   
    def sell_process cost_to_get_paid
    end
end
