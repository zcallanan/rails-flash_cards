class SharedDecksController < ApplicationController
  def index
    @user = current_user
    # list of decks that are globally available
    @decks_global = policy_scope(Deck).where(global_deck_read: true, archived: false)
    kwargs = {
      objects: @decks_global, user: @user, string_type: 'deck_strings', id_type: :deck_id, permission_type: nil, deck: nil
    }
    @decks_global_strings = populate_strings(kwargs)

  end

  private

  def populate_strings(**kwargs)
    # objects ~ decks, string_type ~ 'deck_strings', id_type ~ :deck_id, permission_type ~ 'deck_permissions'
    object_strings = []
    kwargs[:objects].each do |object|
      # prioritize strings that have a user's preferred language
      next if object_strings.pluck(kwargs[:id_type]).include?(object.id)

      languages = object.send(kwargs[:string_type]).pluck(:language)
      if languages.include?(kwargs[:user].language)
        object.send(kwargs[:string_type]).each do |string|
          if string.language == kwargs[:user].language && kwargs[:permission_type].nil?
            object_strings << string
          elsif string.language == kwargs[:user].language
            string.send(kwargs[:permission_type]).each do |permission|
              object_strings << string if string.language == permission.language && permission.user_id == kwargs[:user].id
            end
          end
        end
      else
        # otherwise, return strings of the default language
        object.send(kwargs[:string_type]).each do |string|
          if string.language == object.default_language && kwargs[:deck].nil?
            object_strings << string
          elsif string.language == object.send(kwargs[:deck]).default_language && !kwargs[:deck].nil?
            object_strings << string
          end
        end
      end
    end
    object_strings
  end
end
