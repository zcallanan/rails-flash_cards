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

      languages = object.send(@string_type).pluck(:language)

      if languages.include?(@language)
        object.send(@string_type).each do |string|
          if string.language == @language && @permission_type.nil?
            object_strings << string
          elsif string.language == @language
            string.send(@permission_type).each do |permission|
              object_strings << string if string.language == permission.language && permission.user_id == @user.id
            end
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
    object_strings.uniq(&:id)
  end
end
