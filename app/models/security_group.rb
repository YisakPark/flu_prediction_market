class SecurityGroup < ApplicationRecord
  after_save :update_price
  validates :building_num, numericality: {only_integer: true}
  validates :shares, numericality: {only_integer: true}

  private
    def update_price
      MarketMaker.update_price self.date_market
    end
end
