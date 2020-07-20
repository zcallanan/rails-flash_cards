import Choices from "choices.js"
import { fetchWithToken } from '../utils/fetch_with_token.js';
import { searchCategoryChoices } from '../utils/search_category_choices.js'

const searchSetup = (categorySelect, languageSelect, tagSelect) => {
  // category select setup
  const categoryChoices = new Choices(categorySelect, {
    removeItemButton: true,
    duplicateItemsAllowed: false,
    maxItemCount: 3,
    classNames: {
      containerOuter: 'choices category-select'
    }
  });
  let selectedArray;
  const url_enabled_all = 'http://localhost:3000/api/v1/categories/enabled_all'
  const url_removed_all = 'http://localhost:3000/api/v1/categories/removed_all'
  categoryChoices.passedElement.element.addEventListener('choice', function(e) {
    // User chooses an option from the category select dropdown
    if (e.detail.choice.label !== 'All Categories') {
      // remove all categories if you select a specific category
      fetchWithToken( url_enabled_all, { // all is a choice
        method: "GET",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      })
        .then(response => response.json())
        .then((data) => {
          selectedArray = categoryChoices.getValue() // get all (selected) items in the text field
          setTimeout(() => { // delay is required
            selectedArray.forEach(item => {
              if (item.label === 'All Categories') {
                // if All Categories is found as a selected item, then remove it
                categoryChoices.removeActiveItemsByValue(item.value);
              }
            })
            // generate dropdown options excluding what is selected
            searchCategoryChoices(data, selectedArray, categoryChoices)
          }, 100)
        });
    } else if (e.detail.choice.label === 'All Categories') {
      // remove all other categories from the text field if 'All Categories' is selected
      selectedArray = categoryChoices.getValue()
      selectedArray.forEach(item => {
        if (item.label !== 'All Categories') categoryChoices.removeActiveItemsByValue(item.value)
      })
      fetchWithToken( url_removed_all, { // disable all as a choice
        method: "GET",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      })
        .then(response => response.json())
        .then((data) => {
          setTimeout(() => {
            // get category select options
            searchCategoryChoices(data, selectedArray, categoryChoices)
          }, 100)
        });
    }
  })

  categoryChoices.passedElement.element.addEventListener('removeItem', (e) => {
    // user removes an item from the category select text field
    let url;
    if (Array.from(categoryChoices.passedElement.element.children).length === 0) {
      url = url_removed_all // disable all categories as a choice
    } else {
      url = url_enabled_all // enable all categories as a choice
    }
    fetchWithToken( url, {
    method: "GET",
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
  })
    .then(response => response.json())
    .then((data) => {
      selectedArray = categoryChoices.getValue()
        setTimeout(() => {
          // wait and check if the field is empty. If so, add 'All Categories'
          if (Array.from(categoryChoices.passedElement.element.children).length === 0) categoryChoices.setValue(['All Categories'])
          // get all category select options
          searchCategoryChoices(data, selectedArray, categoryChoices)
        }, 100)
    });
  })

  // language select setup
  const languageChoices = new Choices(languageSelect, {
    classNames: {
      containerOuter: 'choices language-select'
    },
    searchEnabled: true,
    searchPlaceholderValue: 'Type here to find a language.'
  });
  // tag select setup
  const tagChoices = new Choices(tagSelect, {
    removeItemButton: true,
    maxItemCount: 3,
    searchEnabled: true,
    // placeholderValue: 'Type here to find a tag.',
    classNames: {
      containerOuter: 'choices tag-select'
    }
  });
  return [categoryChoices, languageChoices, tagChoices]
}

export { searchSetup }
