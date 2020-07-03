class DeckSearchService
  def initialize(attrs = {})
    @decks = attrs[:decks] || Deck.all
    @language = attrs[:language]
    @category = attrs[:category]
  end

  def call(global = false)
    if global == true
      @decks = @decks.global_search_by_category(@category)

      #@decks = @decks.global_search_by_language(@language)
      @decks
    end
  end
end
