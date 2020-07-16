const buildSearchUrl = (searchUrl) => {
  let categoryArray = []
  const initCategoryString = '\?category%5Bname%5D%5B%5D=';
  const categoryString = '&category%5Bname%5D%5B%5D=';
  const tagString = '&category%5Btag%5D=';
  let categoryValue = '';
  let tagValue = '';
  const options = Array.from(searchUrl.options)
  const languageValue = `&category%5Blanguage%5D=${searchUrl.language}`;

  for (let [index, option] of options.entries()) {
    if (option.label === 'All Categories') {
      categoryArray.push(option.value);
      break;
    } else {
      categoryArray.push(option.value);
    }
  }

  categoryArray.forEach(category => {
    if (categoryArray.indexOf(category) === 0) {
      categoryValue = `${categoryValue}${initCategoryString}${category}`
    } else {
      categoryValue = `${categoryValue}${categoryString}${category}`
    }
  })

  const tagArray = searchUrl.tag.split(', ');
  tagArray.forEach(tag => {
    tagValue = `${tagValue}${tagString}${tag}`
  })
  return `${searchUrl.urlRoute}${searchUrl.dest}${categoryValue}${languageValue}${tagValue}`
}

export { buildSearchUrl }
