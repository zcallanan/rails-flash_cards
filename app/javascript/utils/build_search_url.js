const buildSearchUrl = (searchUrl) => {
  const categoryString = '&category%5Bname%5D%5B%5D=';
  const tagString = '&category%5Btag%5D%5B%5D=';
  let categoryValue = '';
  let tagValue = '';
  const categories = searchUrl.options
  const tags = searchUrl.tag
  if (searchUrl.string === undefined) searchUrl.string = ''
  const titleString = `\?category%5Btitle%5D=${searchUrl.string}`
  const languageValue = `&category%5Blanguage%5D=${searchUrl.language}`;
  let url;

  categories.forEach(category => {
    categoryValue = `${categoryValue}${categoryString}${category}`
  })

  if (tags.length !== 0) { // no tag param if there are no tags -> no tags equivalent to all tags
    tags.forEach(tag => {
      tagValue = `${tagValue}${tagString}${tag}`
    })
  }
  if (searchUrl.topDecks === null) {
    // assemble search url
    url = `${searchUrl.urlRoute}${searchUrl.dest}${titleString}${categoryValue}${languageValue}${tagValue}`
  } else if (searchUrl.topDecks === 'recent_decks') {
    // assemble recent decks search url
    url = `${searchUrl.urlRoute}${searchUrl.topDecks}${titleString}${categoryValue}${languageValue}${tagValue}&dest=${searchUrl.dest}`
  } else if (searchUrl.topDecks === 'rated_decks') {
    // assemble rated decks search url
    url = `${searchUrl.urlRoute}${searchUrl.topDecks}${titleString}${categoryValue}${languageValue}${tagValue}&dest=${searchUrl.dest}`
  }

  return url
}

export { buildSearchUrl }
