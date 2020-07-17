const buildSearchUrl = (searchUrl) => {
  const initCategoryString = '\?category%5Bname%5D%5B%5D=';
  const categoryString = '&category%5Bname%5D%5B%5D=';
  const tagString = '&category%5Btag%5D%5B%5D=';
  let categoryValue = '';
  let tagValue = '';
  const categories = searchUrl.options
  const tags = searchUrl.tag
  const languageValue = `&category%5Blanguage%5D=${searchUrl.language}`;

  categories.forEach(category => {
    if (categories.indexOf(category) === 0) {
      categoryValue = `${categoryValue}${initCategoryString}${category}`
    } else {
      categoryValue = `${categoryValue}${categoryString}${category}`
    }
  })


  if (tags.length !== 0) { // no tag param if there are no tags -> no tags equivalent to all tags
    tags.forEach(tag => {
      tagValue = `${tagValue}${tagString}${tag}`
    })
  }

  const url = `${searchUrl.urlRoute}${searchUrl.dest}${categoryValue}${languageValue}${tagValue}`
  return url
}

export { buildSearchUrl }
