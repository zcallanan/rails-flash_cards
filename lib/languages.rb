module Languages
  mattr_accessor :list

  language_file_path = File.expand_path('languages.json', __dir__)
  language_file = File.read(language_file_path)
  self.list = JSON.parse(language_file)

  def self.search
    languages = Deck.all.pluck(:default_language)
    language_hash = {}
    Languages.list.each { |key, value| language_hash[key] = value if languages.include?(value) }
    language_hash
  end
end
