class SetPastPriceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Security.update_past_price    
    SetPastPriceJob.set(wait_until: Date.tomorrow.midnight).perform_later
  end
end
