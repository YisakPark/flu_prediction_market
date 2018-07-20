class PastPrice < ApplicationRecord
  validates :building_num, numericality: {only_integer: true}
end
