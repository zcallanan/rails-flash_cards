class DeckSearchService
  def initialize(attrs = {})
    @decks = attrs[:decks] || Deck.all
    @language = attrs[:language] || 'en'
    @string = attrs[:string] || nil
    @categories = attrs[:categories] || [Category.where(name: 'All Categories')]
    @tags = attrs[:tags] || nil
    @recent_decks = attrs[:recent_decks] || nil
    @rated_decks = attrs[:rated_decks] || nil
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
    elsif kwargs[:allmydecks] # my most recent decks category search
      @decks = @decks.allmydecks_search_by_categories(@categories, @user) unless @categories.nil?
    elsif kwargs[:allshared] # shared most recent decks category search
      @decks = @decks.allshared_search_by_categories(@categories, @user) unless @categories.nil?
    end

    # if search string is not nil, then remove all whitespaces and see if there's anything left to search
    whitespaces_removed = @string.gsub(/\s+/, "") unless @string.nil?
    @string = nil if whitespaces_removed == ''

    # reduce deck list to those with child deck strings of @language
    @decks = @decks.search_by_title_and_language(@language, @string) unless @language.nil? # should always have one value

    # reduce deck list by tags

    @decks = @decks.search_by_tags(@tags) unless @tags.nil? # can be empty or array

    # handle recent decks request
    @decks = @decks.recent_decks(@user, 'Deck viewed', 3) unless @recent_decks.nil?

    # handle rated decks request
    unless @rated_decks.nil?
      @decks = @decks.rated_decks(4.0) # recommend decks with a rating > 4
      @decks.size <= 3 ? @decks : @decks.sample(3) # return a random set of 3 if there are more than 3
    end

    @decks
  end
end
