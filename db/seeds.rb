user = User.create!(
      :email                 => "parkisaac1018@gmail.com",
      :password              => "123456",
      :password_confirmation => "123456",
      :confirmed_at          => '2018-01-06 05:34:04.893681',
      :confirmation_sent_at  => ' 2018-01-06 05:33:57.494583',
      :share_quantity        => 0,
      :money                 => 10000
)

user2 = User.create!(
      :email                 => "isaac1018@naver.com",
      :password              => "123456",
      :password_confirmation => "123456",
      :confirmed_at          => '2018-01-06 05:34:04.893681',
      :confirmation_sent_at  => ' 2018-01-06 05:33:57.494583',
      :share_quantity        => 0,
      :money                 => 100
)

Building.create!(
      :building_num              => 102,
      :name                  => "Engineering Building I"
)

Building.create!(
      :building_num              => 104,
      :name                  => "Engineering Building II"
)

Building.create!(
      :building_num              => 106,
      :name                  => "Engineering Building III"
)

Building.create!(
      :building_num              => 108,
      :name                  => "Natural Science Building"
)

Building.create!(
      :building_num              => 110,
      :name                  => "Engineering building IV"
)

Building.create!(
      :building_num              => 112,
      :name                  => "Engineering building V"
)

Building.create!(
      :building_num              => "403",
      :name                  => "Faculty Residence"
)

Building.create!(
      :building_num              => 404,
      :name                  => "Faculty Residence"
)

Building.create!(
      :building_num              => 114,
      :name                  => "Business Administration Building"
)

Building.create!(
      :building_num              => 101,
      :name                  => "Dormitory"
)

7.times do |i|
  Building.all.each do |building|
    SecurityGroup.create!(
      	    date_market: (Time.now + i.days).strftime("%m/%d/%Y"),
	    building_num: building.building_num,
	    shares: 0)
  end
  MarketMaker.update_price (Time.now + i.days).strftime("%m/%d/%Y")
end


#
#order1 = Order.create!(user_id: user2.id,
#                       security_ids: [1],
#                       quantity: 10,
#                       order_type: "buy") 
#
#order2 = Order.create!(user_id: user2.id,
#                       security_ids: [2],
#                       quantity: 20,
#                       order_type: "buy") 
#
#order3 = Order.create!(user_id: user2.id,
#                       security_ids: [3],
#                       quantity: 24,
#                       order_type: "buy") 
#
#order4 = Order.create!(user_id: user2.id,
#                       security_ids: [4],
#                       quantity: 4,
#                       order_type: "buy") 
#
#order1.process
#order2.process
##order3.process
#order4.process
#
