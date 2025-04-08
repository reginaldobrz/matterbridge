require 'net/http'
require 'json'

class TranslationService
  def self.translate_to_english(text)
    translate(text, 'portuguese', 'english')
  end

  def self.translate_to_portuguese(text)
    translate(text, 'english', 'portuguese')
  end

  def self.translate(text, source_lang, target_lang)
    uri = URI("https://api.openai.com/v1/chat/completions")

    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = "Bearer #{ENV['OPENAI_API_KEY']}"
    req['Content-Type'] = 'application/json'
    req.body = {
      model: "gpt-3.5-turbo",
      messages: [
        { role: "system", content: "You are a helpful assistant that only translates #{source_lang} to #{target_lang}." },
        { role: "user", content: text }
      ],
      temperature: 0.2
    }.to_json

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    parsed = JSON.parse(res.body)
    parsed.dig("choices", 0, "message", "content") || "[Erro na tradução]"
  rescue => e
    "[Erro na tradução: #{e.message}]"
  end
end
