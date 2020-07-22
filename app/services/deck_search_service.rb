class DeckSearchService
  def initialize(attrs = {})
    @decks = attrs[:decks] || Deck.all
    @language = attrs[:language] || 'en'
    @string = attrs[:string] || nil
    @categories = attrs[:categories] || [Category.where(name: 'All Categories')]
    @tags = attrs[:tags] || nil
    @user = attrs[:user]
  end

  def call(**kwargs)
    if kwargs[:global]
      # reduce deck list to those with @category id
      @decks = @decks.global_search_by_categories(@categories) unless @categories.nil? # multi select or empty string
    elsif kwargs[:mydecks]
      @decks = @decks.mydecks_search_by_categories(@categories, @user, false) unless @categories.nil?

    elsif kwargs[:myarchived]
      @decks = @decks.mydecks_search_by_categories(@categories, @user, true) unless @categories.nil?

    elsif kwargs[:shared_read]
      @decks = @decks.shared_search_by_categories(@categories, @user, false) unless @categories.nil?
    elsif kwargs[:shared_update]
      @decks = @decks.shared_search_by_categories(@categories, @user, true) unless @categories.nil?
    end
    # if search string is not nil, then remove all whitespaces and see if there's anything left to search
    @string.nil? ? whitespaces_removed = '' : whitespaces_removed = @string.gsub(/\s+/, "")
    @string = nil if whitespaces_removed == ''

    # reduce deck list to those with child deck strings of @language
    @decks = @decks.search_by_title_and_language(@language, @string) unless @language.nil? # should always have one value

    # reduce deck list by tags

    @decks = @decks.search_by_tags(@tags) unless @tags.nil? # can be empty or array
    @decks
  end
end
