class DeckSearchService
  def initialize(attrs = {})
    @decks = attrs[:decks] || Deck.all
    @language = attrs[:language]
    @category = attrs[:category]
  end

  def call(global = false)
    if global == true
      # reduce deck list to those with @category id
      @decks = @decks.global_search_by_category(@category)
      # reduce deck list to those with child deck strings of @language
      @decks = @decks.global_search_by_language(@language)
      @decks
    end
  end
end
