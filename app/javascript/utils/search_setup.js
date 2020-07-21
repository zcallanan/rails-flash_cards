import Choices from "choices.js"
import { fetchWithToken } from '../utils/fetch_with_token.js';
import { searchCategoryChoices } from '../utils/search_category_choices.js'

const searchSetup = (categorySelect, languageSelect, tagSelect, controller) => {
  // category select setup
  let categoryChoices;
  let languageChoices;
  let tagChoices;
  if (controller === 'pages') {
    categoryChoices = new Choices(categorySelect, {
      duplicateItemsAllowed: false,
      classNames: {
        containerOuter: 'choices pages-category-select-outer',
        containerInner: 'choices__inner pages-category-select-inner'
      }
    });
    languageChoices = new Choices(languageSelect, {
      classNames: {
        containerOuter: 'choices pages-language-select-outer',
        containerInner: 'choices__inner pages-language-select-inner'
      },
      searchEnabled: true,
      searchPlaceholderValue: 'Type here to find a language.'
    });
    tagChoices = new Choices(tagSelect, {
      searchEnabled: true,
      classNames: {
        containerOuter: 'choices pages-tag-select-outer',
        containerInner: 'choices__inner pages-tag-select-inner'
      }
    });
  } else if (controller === 'decks') {
    categoryChoices = new Choices(categorySelect, {
      duplicateItemsAllowed: false,
      classNames: {
        containerOuter: 'choices decks-category-select-outer',
        containerInner: 'choices__inner decks-category-select-inner'
      }
    });
    languageChoices = new Choices(languageSelect, {
      classNames: {
        containerOuter: 'choices decks-language-select-outer',
        containerInner: 'choices__inner decks-language-select-inner'
      },
      searchEnabled: true,
      searchPlaceholderValue: 'Type here to find a language.'
    });
    tagChoices = new Choices(tagSelect, {
      searchEnabled: true,
      classNames: {
        containerOuter: 'choices decks-tag-select-outer',
        containerInner: 'choices__inner decks-tag-select-inner'
      }
    });
  }
  console.log(categoryChoices)
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
  return [categoryChoices, languageChoices, tagChoices]
}

export { searchSetup }
