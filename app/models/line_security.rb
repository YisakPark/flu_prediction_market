class LineSecurity < ApplicationRecord
  belongs_to :user
  belongs_to :security
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 10000000 }
  default_scope -> { order(quantity: :desc) }

  public

    #save the update with validation. if it's not valid return false
    def save_with_validation?
      if self.valid?
        self.save
        return true
      else
        return false
      end
    end

  private
    #update corresponding security quantity with the amount that line_security quantity has changed and remove other equivalent line security which has same user_id and security_id
    def update_security_quantity_and_remove_other_equivalent_line_security
      #somehow Security.find(self.security_id).assign_attributes doesn't work, so that I use different way to assign attributes.
      security = Security.find(self.security_id)
      security.assign_attributes(quantity: security.quantity + self.quantity)
      raise InvalidSecurityQuantity unless security.save_with_validation?
      #remove another equivalent line security
      equivalent_line_security = LineSecurity.find_by("user_id = '#{self.user_id}' AND security_id = '#{self.security_id}' AND id != '#{self.id}'")
      if(equivalent_line_security)
        self.update_columns(quantity: self.quantity + equivalent_line_security.quantity)
        equivalent_line_security.destroy
      end
    end
 
end
