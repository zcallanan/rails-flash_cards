class DeckSearchService
  def initialize(attrs = {})
    @decks = attrs[:decks] || Deck.all
    @language = attrs[:language] || 'en'
    @categories = attrs[:categories] || [Category.where(name: 'All Categories')]
    @tags = attrs[:tags]
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
    # reduce deck list to those with child deck strings of @language
    @decks = @decks.search_by_language(@language) unless @language.nil? # should always have one value
    # reduce deck list by tags
    unless @tags.nil?
      @tags = nil if @tags.empty?
    end

    @decks = @decks.search_by_tags(@tags) unless @tags.nil? # can be empty or array

    @decks
  end
end
