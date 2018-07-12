class Security < ApplicationRecord
  has_many :line_securities, dependent: :destroy
  default_scope -> { order(id: :asc) }
  validates :building_number, presence: true
  validates :event, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 100 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 10000000 }
  validates :past_price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 100 }

  public
   
    #get the price difference between past price and current price
    def get_price_difference
      if( (Time.current - self.updated_at) >= 2 * Security.PRICE_UPDATE_CONSTANT )
        0
      else
        self.price - self.past_price
      end
    end

    #get the range of date for securities.
    def self.DATE_RANGE
      7
    end

    #get the range of space for securities.
    def self.SPACE_RANGE
      9
    end

    #get cost to buy(or sell) the share of security with the amount of passed quantity. quantity will be positive if buy and negative if sell.
    def self.get_cost(*args)
      prior_investment_amount = Security.get_investment_amount()
      posterior_investment_amount = 0
      case args.size
      when 1
        #if there is one argument, it is the hash whose key is security id and value is quantity corrseponding to security id
        posterior_investment_amount = Security.get_investment_amount(args[0])
      when 2
        #if there are 2 arguments, first argument is security_ids and second is quantity
        posterior_investment_amount = Security.get_investment_amount(args[0], args[1])
      else
        raise "Invalid number of argument in Security.get_cost!"
      end
      return (posterior_investment_amount - prior_investment_amount).abs
    end
   
    #get investment amount to calculate the cost. If there is no parameter, it calculates current investment amount, otherwise investment amount with the share quantity of specified security. 'security_ids' is a array of securities to be bought or sold
    def self.get_investment_amount(*args)
      value_inside_log = 0
      updated_quantity_arr = {}
      security_ids = nil
      quantity = 0
      case args.size
      when 0
        #function call with no argument will calculate current investment amount
      when 1
        #if there is one argument, it is the hash whose key is security id and value is quantity that user bought
        hash = args[0]
        security_ids = []
        hash.each do |key, value|
          security_id = key.to_s.to_i
          #update security_ids which is the array of security id that user want to buy or sell
          security_ids.push(security_id)
          #make hash whose key is id of security and value is updated quantity
          updated_quantity_arr[key] = Security.find(security_id).quantity + value
        end
      when 2
        security_ids = args[0]
        quantity = args[1]
        #make hash whose key is id of security and value is updated quantity
        security_ids.each do |security_id|
          key = security_id.to_s.to_sym 
          value = Security.find(security_id).quantity + quantity
          updated_quantity_arr[key] = value
        end
      else
        raise "Invalid number of argument of Security.get_investment_amount!"
      end
      
      #calculate value_inside_log
      Security.all.each do |security|
        #if security_ids is given and security.id is the id of security that user tries to buy or sell, use the quantity given in updated_quantity_arr
        unless security_ids == nil
          if security_ids.include?(security.id)
            key = security.id.to_s.to_sym
            value_inside_log += Math.exp( updated_quantity_arr[key] / Security.LIQUIDITY_PARAM )
            next
          end
        end
        value_inside_log += Math.exp(security.quantity / Security.LIQUIDITY_PARAM)
      end 
      Security.LIQUIDITY_PARAM * Math.log(value_inside_log) 
    end

    def save_with_validation?
      if self.valid?
        self.save
        return true
      else
        return false
      end
    end

    #this liquidity parameter is same as used in Gates Hillman prediction market
    def self.LIQUIDITY_PARAM
      32
    end

    def self.update_price
      denominator = get_denominator
      Security.all.each do |security|
        updated_price = get_numerator(security.quantity)/denominator
        security.update_columns(price: updated_price)
      end 
    end
 
    #get what rate the price has changed.
    def self.get_price_change_rate(curr_price, past_price)
      change_rate = curr_price / past_price 
      #return value tells how much the price has changed. The greater number attached at the end, the greater change occured" 
      case
      when 1.75 <= change_rate
        return "increased_rate4"
      when 1.5 <= change_rate && change_rate < 1.75
        return "increased_rate3"
      when 1.25 <= change_rate && change_rate < 1.5
        return "increased_rate2"
      when 1.0 < change_rate && change_rate < 1.25
        return "increased_rate1"
      #nothing will be done when change_rate = 1
      when 0.75 <= change_rate && change_rate < 1.0
        return "decreased_rate1"
      when 0.5 <= change_rate && change_rate < 0.75
        return "decreased_rate2"
      when 0.25 <= change_rate && change_rate < 0.5
        return "decreased_rate3"
      when 0.0 <= change_rate && change_rate < 0.25
        return "decreased_rate4"
      end
    end

  private
 
    def self.update_past_price
      Security.all.each do |security|
        security.update_columns(past_price: security.price, past_price_updated_at: Time.now)
      end
    end
 
    def self.get_denominator
      denominator = 0
      Security.all.each do |security|
        denominator += Math.exp(security.quantity/Security.LIQUIDITY_PARAM)
      end  
      denominator
    end

    def self.get_numerator(quantity)
      Math.exp(quantity/Security.LIQUIDITY_PARAM)
    end

end
