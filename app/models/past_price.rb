class PastPrice < ApplicationRecord
  validates :building_num, numericality: {only_integer: true}

  #get what rate the price of the security_group specified by
  #'security_group_id' has changed
  def self.get_price_change_rate(security_group_id)
    past_price = 
      PastPrice.where(security_group_id: security_group_id).order("created_at").last.past_price
    curr_price = SecurityGroup.find(security_group_id).price
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

  def self.update_past_price
    SecurityGroup.where(isClosed?: false).each do |security_group|
      PastPrice.create!(
	date_market: security_group.date_market,
	building_num: security_group.building_num,
	security_group_id: security_group.id,
	past_price: security_group.price)
    end
  end
end
