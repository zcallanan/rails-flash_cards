import Choices from "choices.js"
import { fetchWithToken } from '../utils/fetch_with_token.js';

const searchSetup = (categorySelect, languageSelect, tagSelect) => {
  let url;
  let selectedArray;
  // category select setup
  const categoryChoices = new Choices(categorySelect, {
    removeItemButton: true,
    duplicateItemsAllowed: false,
    maxItemCount: 3,
    classNames: {
      containerOuter: 'choices category-select'
    }
  });
  categoryChoices.passedElement.element.addEventListener('choice', function(e) {
    selectedArray = categoryChoices.getValue()
    console.log(selectedArray)
    if (e.detail.choice.label !== 'All Categories') {
      console.log(e.detail.choice.label)
      // remove all categories if you select a specific category
      fetchWithToken( 'http://localhost:3000/api/v1/categories/enabled_all', { // all is a choice
        method: "GET",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      })
        .then(response => response.json())
        .then((data) => {
          selectedArray = categoryChoices.getValue()
          console.log('Not all categories selected')
          setTimeout(() => {
            selectedArray.forEach(item => {
              if (item.label === 'All Categories') {
                categoryChoices.removeActiveItemsByValue(item.value);
              }
            })
            // repopulate choices with 'All Categories'
            let array = [];
            let n = 1;
            let obj;
            data.forEach(row => {
              row[1].forEach(item => {
                selectedArray.forEach(currentlyDisabled => {

                  if (currentlyDisabled.value === item.value) {
                    item['disabled'] = true;
                  }
                })
              })

              obj = {label: row[0], id: n, disabled: false, choices: row[1]}

              array.push(obj);
              n = n + 1
            })
            categoryChoices.setChoices(array, 'value', 'label', true);
          }, 100)
        });
    } else if (e.detail.choice.label === 'All Categories') {

      // remove all other categories if all is selected
      categoryChoices._currentState.items.filter(function (item) {
        console.log('All categories selected. Remove others')
        for (let key in item) {
          if (key === 'label' && item[key] !== 'All Categories') {
            categoryChoices.removeActiveItemsByValue(item.value);
          }
        }
      })
      fetchWithToken( 'http://localhost:3000/api/v1/categories/removed_all', { // disable all as a choice
        method: "GET",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      })
        .then(response => response.json())
        .then((data) => {
          console.log('All Categories selected')
          selectedArray = categoryChoices.getValue()

          setTimeout(() => {
            // repopulate choices with 'All Categories'
            let array = [];
            let n = 1;
            let obj;
            data.forEach(row => {
              row[1].forEach(item => {
                selectedArray.forEach(currentlyDisabled => {

                  if (currentlyDisabled.value === item.value) {
                    item['disabled'] = true;
                  }
                })
              })

              obj = {label: row[0], id: n, disabled: false, choices: row[1]}

              array.push(obj);
              n = n + 1
            })
            categoryChoices.setChoices(array, 'value', 'label', true);
          }, 100)
        });
    }
  })


  // ensure the categories selector is not empty. There's a delay to avoid this firing if you're selecting another category
    categoryChoices.passedElement.element.addEventListener('removeItem', (e) => {
      if (Array.from(categoryChoices.passedElement.element.children).length === 0) {
        url = 'http://localhost:3000/api/v1/categories/removed_all' // disable all categories as a choice
      } else {
        url = 'http://localhost:3000/api/v1/categories/enabled_all' // enable all categories as a choice
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
            if (Array.from(categoryChoices.passedElement.element.children).length === 0) categoryChoices.setValue(['All Categories'])
            // repopulate choices with 'All Categories'
            let array = [];
            let n = 1;
            let obj;
            data.forEach(row => {
              row[1].forEach(item => {
                selectedArray.forEach(currentlyDisabled => {
                  if (currentlyDisabled.value === item.value) {
                    item['disabled'] = true;
                  }
                })
              })

              obj = {label: row[0], id: n, disabled: false, choices: row[1]}

              array.push(obj);
              n = n + 1
            })
            categoryChoices.setChoices(array, 'value', 'label', true);
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
    searchPlaceholderValue: 'Type here to find a tag.',
    classNames: {
      containerOuter: 'choices tag-select'
    }
  });
  return [categoryChoices, languageChoices, tagChoices]
}

export { searchSetup }
