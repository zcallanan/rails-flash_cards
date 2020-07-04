class PopulateStrings
  def initialize(attrs = {})
    @objects = attrs[:objects]
    @id_type = attrs[:id_type]
    @string_type = attrs[:string_type]
    @user = attrs[:user]
    @permission_type = attrs[:permission_type]
    @deck = attrs[:deck]
    @language ||= attrs[:language] # user may not exist in the case of global read
    @language ||= @user.language if @user.nil? == false
  end

  def call
    # objects ~ decks, string_type ~ 'deck_strings', id_type ~ :deck_id, permission_type ~ 'deck_permissions'
    object_strings = []
    @objects.each do |object|
      # prioritize strings that have a user's preferred language
      next if object_strings.pluck(@id_type).include?(object.id)

      languages = object.send(@string_type).pluck(:language) # languages that exist for a string
      if languages.include?(@language)  # do any of the existing strings match the @language in focus?
        object.send(@string_type).each do |string| # aka: decks.deck_strings.each |string|
          if string.language == @language && @permission_type.nil? # string.language == focus language AND we don't need to check your permission because you own it
            object_strings << string
          elsif @permission_type.nil? == false && object.send(@permission_type).pluck(:user_id).include?(@user.id)
            # check if object.permission_types includes your user.id
            object_strings << string
          end
        end
      else
        # otherwise, return strings of the default language
        object.send(@string_type).each do |string|
          if string.language == object.default_language && @deck.nil?
            object_strings << string
          elsif string.language == object.send(@deck).default_language && !@deck.nil?
            object_strings << string
          end
        end
      end
    end
    object_strings.uniq { |string| string.send(@id_type) }
  end
end
