class Share < ApplicationRecord
  validates :sell_price, numericality: { greater_than_or_equal_to: 0 }
  validates :buy_price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  
end
