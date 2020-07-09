class DeckSearchService
  def initialize(attrs = {})
    @decks = attrs[:decks] || Deck.all
    @language = attrs[:language]
    @categories = attrs[:categories]
    @tags = attrs[:tags]
  end

  def call(global = false)
    if global == true
      # reduce deck list to those with @category id
      @decks = @decks.global_search_by_categories(@categories) unless @categories.nil? # multi select or empty string
      # reduce deck list to those with child deck strings of @language
      @decks = @decks.global_search_by_language(@language) unless @language.nil? # should always have one value
      # reduce deck list by tags
      @decks = @decks.global_search_by_tags(@tags) unless @tags.nil? # can be nil, one, or comma separated string
      @decks
    end
  end
end
