require 'net/http'
require 'uri'
require 'json'

class SlackService
  def self.send_message(text)
    url = ENV['SLACK_WEBHOOK_URL']
    raise "SLACK_WEBHOOK_URL não definido ou vazio" if url.nil? || url.strip.empty?

    uri = URI.parse(url)
    header = { 'Content-Type': 'application/json' }
    body = { text: text }.to_json

    Net::HTTP.post(uri, body, header)
  end
end
