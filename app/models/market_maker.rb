class MarketMaker < ApplicationRecord

  #get cost to buy(or sell) the share of security with the amount of passed quantity. quantity will be positive if buy and negative if sell.
	#'order info' is the hash, where the key is security group id and the value is
  # the quantity of the share specified by the security group id.
  def self.get_cost order_info
		sort_by_date = {}
		order_info.each do |security_group_id, quantity|
			date = get_date_market(security_group_id.to_s.to_i).to_sym
			if sort_by_date[date].nil?
				sort_by_date[date] = {}
			  sort_by_date[date][security_group_id.to_sym] = quantity
			else 
				if sort_by_date[date][security_group_id].nil?
					sort_by_date[date][security_group_id] = quantity
				else
					sort_by_date[date][security_group_id] += quantity
				end
			end
		end

		prior_investment_amount = 0
		posterior_investment_amount = 0

		sort_by_date.each do |date, hash|
			prior_investment_amount += MarketMaker.get_investment_amount(date.to_s)
			posterior_investment_amount += MarketMaker.get_investment_amount(date.to_s, hash)
		end

    return (posterior_investment_amount - prior_investment_amount).abs
  end

  #get investment amount to calculate the cost. If there is one parameter, it calculates current investment amount of market specified in the argument, otherwise investment amount with the share quantity of specified security. 'building_nums' is a array of buildings to be bet on
  #if the number of argument is one, it is the date of market
  #if 2, first: date of market, second: hash where key is security group id and the value is the number of share quantity
    def self.get_investment_amount(*args)
    value_inside_log = 0
    updated_quantity_hash = {}
    date_market = args[0]

    case args.size
    when 1
    when 2
			updated_quantity_hash = args[1]
      #make hash whose key is security_group_id and value is updated number of shares
			updated_quantity_hash.each do |security_group_id, quantity|
				updated_quantity_hash[security_group_id] += 
						SecurityGroup.find(security_group_id.to_s).shares
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
				if updated_quantity_hash[security_group.id.to_s.to_sym].nil?
					value_inside_log += 
							Math.exp(security_group.shares / MarketMaker.LIQUIDITY_PARAM)
				else
					value_inside_log += 
							Math.exp(updated_quantity_hash[security_group.id.to_s.to_sym] / MarketMaker.LIQUIDITY_PARAM)
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

  def self.get_date_market security_group_id
    SecurityGroup.find(security_group_id).date_market
  end

  def self.get_security_group_id date_market, building_num
    SecurityGroup.find_by(date_market: date_market, building_num: building_num).id
  end
end
