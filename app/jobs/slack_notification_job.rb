class SlackNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(webhook_url, options = {})
    Net::HTTP.post_form(URI.parse(webhook_url), payload: options.to_json)
  end
end
