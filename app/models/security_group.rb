class SecurityGroup < ApplicationRecord
  validates :building_num, numericality: {only_integer: true}
  validates :shares, numericality: {only_integer: true}
end
