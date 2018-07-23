class LineShare < ApplicationRecord
  after_save :update_lineshare_quantity_and_remove_other_equivalent_line_share
  belongs_to :user
  validates :quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true}
  validates :building_num, numericality: {only_integer: true}
  validates :flu_population_rate, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
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
    #update corresponding security quantity with the amount that line_share quantity has changed and remove other equivalent line_share
    def update_lineshare_quantity_and_remove_other_equivalent_line_share
      equivalent_line_share = LineShare.find_by(
          "user_id = '#{self.user_id}' " +
          "AND security_group_id = '#{self.security_group_id}' " +
          "AND flu_population_rate = '#{self.flu_population_rate}' " + 
          "AND available = true " + 
          "AND id != '#{self.id}'")
      if(equivalent_line_share)
        self.update_columns(quantity: self.quantity + equivalent_line_share.quantity)
        equivalent_line_share.destroy
      end
    end
 
end
