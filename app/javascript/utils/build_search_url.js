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

  categories.forEach(category => {
    categoryValue = `${categoryValue}${categoryString}${category}`
  })

  if (tags.length !== 0) { // no tag param if there are no tags -> no tags equivalent to all tags
    tags.forEach(tag => {
      tagValue = `${tagValue}${tagString}${tag}`
    })
  }

  const url = `${searchUrl.urlRoute}${searchUrl.dest}${titleString}${categoryValue}${languageValue}${tagValue}`
  return url
}

export { buildSearchUrl }
