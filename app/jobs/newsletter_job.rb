class NewsletterJob < ApplicationJob
  queue_as :default

  def perform(str)
      puts "periodic job"
      NewsletterJob.set(wait: 60).perform_later "periodic" 
  end
end
