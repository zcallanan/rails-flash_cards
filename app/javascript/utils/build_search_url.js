const buildSearchUrl = (search_url) => {
  let categoryArray = []
  const initCategoryString = '\?category%5Bname%5D%5B%5D=';
  const categoryString = '&category%5Bname%5D%5B%5D=';
  const tagString = '&category%5Btag%5D=';
  let categoryValue = '';
  let tagValue = '';

  const languageValue = `&category%5Blanguage%5D=${search_url.language}`;
  search_url.options.forEach(option => {
    if (option.selected === true) categoryArray.push(option.value)
  })
  const tagArray = search_url.tag.split(', ');
  categoryArray.forEach(category => {
    if (categoryArray.indexOf(category) === 0) {
      categoryValue = `${categoryValue}${initCategoryString}${category}`
    } else {
      categoryValue = `${categoryValue}${categoryString}${category}`
    }
  })
  tagArray.forEach(tag => {
    tagValue = `${tagValue}${tagString}${tag}`
  })
  return `${search_url.urlRoute}${search_url.dest}${categoryValue}${languageValue}${tagValue}`
}

export { buildSearchUrl }
