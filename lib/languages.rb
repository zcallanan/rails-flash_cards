module Languages
  mattr_accessor :list

  language_file_path = File.expand_path('languages.json', __dir__)
  language_file = File.read(language_file_path)
  self.list = JSON.parse(language_file)
end
