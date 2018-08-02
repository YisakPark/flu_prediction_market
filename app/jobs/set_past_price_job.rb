class SetPastPriceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PastPrice.update_past_price    
    SetPastPriceJob.set(wait_until: Date.tomorrow.midnight).perform_later
  end
end
