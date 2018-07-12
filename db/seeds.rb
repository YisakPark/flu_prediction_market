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
      :number              => "102",
      :floors                => 8,
      :name                  => "Engineering Building I"
)

Building.create!(
      :number              => "104",
      :floors                => 8,
      :name                  => "Engineering Building II"
)

Building.create!(
      :number              => "106",
      :floors                => 8,
      :name                  => "Engineering Building III"
)

Building.create!(
      :number              => "108",
      :floors                => 8,
      :name                  => "Natural Science Building"
)

Building.create!(
      :number              => "110",
      :floors                => 8,
      :name                  => "Engineering building IV"
)

Building.create!(
      :number              => "112",
      :floors                => 8,
      :name                  => "Engineering building V"
)

Building.create!(
      :number              => "403",
      :floors                => 8,
      :name                  => "Faculty Residence"
)

Building.create!(
      :number              => "404",
      :floors                => 8,
      :name                  => "Faculty Residence"
)

Building.create!(
      :number              => "114",
      :floors                => 8,
      :name                  => "Business Administration Building"
)

Building.create!(
      :number              => "101",
      :floors                => 8,
      :name                  => "Dormitory"
)

Building.all.each do |building|
  building.floors.times do |floor|
    Security.DATE_RANGE.times do |date|
      Security.create!(
        building_number: building.number,
        event: "#{building.number}-#{floor+1},#{date+1}",
        price: 0,
        quantity: 0
      )
      puts "#{building.number}-#{floor+1},#{date+1}"
    end
  end
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
