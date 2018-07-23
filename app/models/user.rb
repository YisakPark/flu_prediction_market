class User < ApplicationRecord
  has_many :line_securities, dependent: :destroy
  has_many :orders
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates :share_quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :money, numericality: { greater_than_or_equal_to: 0, less_than: 10000000 }
  def hello
    puts "hello"
  end
  
  #get quantity of shares that user bought
  def get_shares_quantity
    quantity = 0
    LineShare.where(user_id: self.id, available: true).each do |lineshare|
      quantity += lineshare.quantity
    end  
    quantity
  end

  #get user array sort by asset in descending order
  def self.get_user_arr_sort_by_asset
    asset_arr = []
    User.all.each do |user|
      asset = user.get_asset
      asset_arr.push( {id: user.id, asset: asset} )
    end
    asset_arr.sort_by { |elem| elem[:asset] }.reverse
  end

  #get asset of user
  def get_asset
    asset = self.money
    sell_hash = {}
    #make has whose key is id of security and value is quantity that user bought
    LineShare.where(user_id: self.id, available: true).each do |lineshare|
      key = lineshare.security_id.to_s.to_sym
      #because this is the hash for selling, qunatity will be negative
      value = - linesecurity.quantity
      sell_hash[key] = value
    end
    asset += Security.get_cost(sell_hash)
    asset.round(4)
  end
end
