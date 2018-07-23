class MarketMaker < ApplicationRecord

  #get cost to buy(or sell) the share of security with the amount of passed quantity. quantity will be positive if buy and negative if sell.
  #'date_market' is the date of market, 'security_group_ids' is the array of security_group_id, 'quanaitiy' is the quantity of shares to be bought
  def self.get_cost(date_market, security_group_ids, quantity)
    prior_investment_amount = MarketMaker.get_investment_amount(date_market)
    posterior_investment_amount = MarketMaker.get_investment_amount(date_market, security_group_ids, quantity)
    return (posterior_investment_amount - prior_investment_amount).abs
  end

  #get investment amount to calculate the cost. If there is one parameter, it calculates current investment amount of market specified in the argument, otherwise investment amount with the share quantity of specified security. 'building_nums' is a array of buildings to be bet on
  #if the number of argument is one, it is the date of market
  #if 3, first: date of market, second: array of 'security_group_ids', third: the numberof share quantity
    def self.get_investment_amount(*args)
    value_inside_log = 0
    updated_quantity_arr = {}
    building_nums = nil
    quantity = 0
    date_market = nil

    date_market = args[0]

    case args.size
    when 1
    when 3
      security_group_ids = args[1]
      quantity = args[2]
      #make hash whose key is security_group_id and value is updated number of shares
      security_group_ids.each do |security_group_id|
        key = security_group_id.to_s.to_sym
	value = SecurityGroup.find(security_group_id).shares + quantity
	updated_quantity_arr[key] = value
      end


    else
      raise "Invalid number of argument of MarketMaker.get_investment_amount!"
    end


    #calculate value_inside_log
    #calculate current investment amount, when args.size = 0
    if args.size == 1
      SecurityGroup.where(date_market: date_market).each do |security_group|
        value_inside_log += Math.exp(security_group.shares / MarketMaker.LIQUIDITY_PARAM)
      end
    #calculate investment amount with updated quantity, when args.size != 0
    else
      SecurityGroup.where(date_market: date_market).each do |security_group|
        if security_group_ids.include?(security_group.id)
          key = security_group.id.to_s.to_sym
	  value_inside_log += Math.exp(updated_quantity_arr[key] / MarketMaker.LIQUIDITY_PARAM)
	else
	  value_inside_log += Math.exp(security_group.shares / MarketMaker.LIQUIDITY_PARAM)
	end
      end
    end

    MarketMaker.LIQUIDITY_PARAM * Math.log(value_inside_log)
  end

  def self.LIQUIDITY_PARAM
    32.0
  end

  #update price of the market specified by 'date_market'
  def self.update_price date_market
    denominator = 0
    numerator = 0

    #get denominator 
    SecurityGroup.where(date_market: date_market).each do |security_group|
      denominator += Math.exp(security_group.shares / MarketMaker.LIQUIDITY_PARAM)
    end

    #get numerator for each security_group
    SecurityGroup.where(date_market: date_market).each do |security_group|
      numerator = Math.exp(security_group.shares / MarketMaker.LIQUIDITY_PARAM)
      security_group.update_columns(price: numerator / denominator)
      numerator = 0      
    end
  end
end
