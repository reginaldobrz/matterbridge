require 'json'

class MessageLogger
  FILE_PATH = 'messages.json'

  def self.load_messages
    return [] unless File.exist?(FILE_PATH)
    content = File.read(FILE_PATH)
    content.empty? ? [] : JSON.parse(content)
  rescue => e
    puts "Erro ao carregar mensagens: \#{e.message}"
    []
  end

  def self.log(data)
    messages = load_messages
    messages << data
    File.write(FILE_PATH, JSON.pretty_generate(messages))
  end
end
