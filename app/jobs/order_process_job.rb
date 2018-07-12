class OrderProcessJob < ApplicationJob
  queue_as :default

  #process the order. It could be buy or sell
  def perform(order)
    if order.order_type == "buy"
      buy_process order
      order.update_attributes(isDone: true)
    elsif order.order_type == "sell"
      sell_process order
      order.update_attributes(isDone: true)
    end
  end

   def buy_process order
      user_current_money = User.find(order.user_id).money
      #update user's money and security's quantity which has been sold so far
      User.transaction do
        Security.transaction do
          User.find(order.user_id).update_attributes!(money: user_current_money - order.cost)
          order.security_ids.each do |security_id|
            #increase the quantity of line_security
            if LineSecurity.exists?(user_id: order.user_id, security_id: security_id)
              line_security = LineSecurity.find_by(user_id: order.user_id, security_id: security_id)
              updated_quantity = line_security.quantity + order.quantity
              line_security.update_attributes!(quantity: updated_quantity)
            else 
              LineSecurity.create!( user_id: order.user_id, security_id: security_id, quantity: order.quantity)
            end
            #update corresponding security quantity with the amount that line_security quantity has changed 
            security = Security.find(security_id)
            security.assign_attributes(quantity: security.quantity + order.quantity)
            raise InvalidSecurityQuantity unless security.save_with_validation?
          end 
          #after buy process, update prices of securities
          Security.update_price
        end
      end
    end

    def sell_process order
      user_current_money = User.find(order.user_id).money
      #update user's money and security's quantity which has been sold so far
      User.transaction do
        Security.transaction do
          User.find(order.user_id).update_attributes!(money: user_current_money + order.cost)
          order.security_ids.each do |security_id|
            line_security = LineSecurity.find_by(user_id: order.user_id, security_id: security_id)
            quantity_user_has = line_security.quantity
            #decrease the quantity of line_security
            line_security.update_attributes!(quantity: quantity_user_has - order.quantity)
            #if line_security quantity becomes 0, delete the line_security
            if(line_security.quantity == 0)
              line_security.delete
            end
            #update corresponding security quantity with the amount that line_security quantity has changed 
            security = Security.find(security_id)
            security.assign_attributes(quantity: security.quantity - order.quantity)
            raise InvalidSecurityQuantity unless security.save_with_validation?
          end 
          #after buy process, update prices of securities
          Security.update_price
        end
      end
    end
end
