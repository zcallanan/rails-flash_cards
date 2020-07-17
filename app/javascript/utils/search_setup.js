import Choices from "choices.js"
import { fetchWithToken } from '../utils/fetch_with_token.js';

const searchSetup = (categorySelect, languageSelect, tagSelect) => {
  // category select setup
  const categoryChoices = new Choices(categorySelect, {
    removeItemButton: true,
    duplicateItemsAllowed: false,
    maxItemCount: 5,
    classNames: {
      containerOuter: 'choices category-select'
    }
  });
  categoryChoices.passedElement.element.addEventListener('choice', function(e) {
    if (e.detail.choice.label !== 'All Categories') {
      // remove all categories if you select a specific category
      categoryChoices._currentState.items.filter(function (item) {
        for (let key in item) {
          if (key === 'label' && item[key] === 'All Categories') {
            categoryChoices.removeActiveItemsByValue(item.value);
          }
        }
      })
      fetchWithToken( 'http://localhost:3000/api/v1/categories/enabled_all', {
        method: "GET",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      })
        .then(response => response.json())
        .then((data) => {
          const selectedArray = categoryChoices.getValue()
          console.log(selectedArray)
          if (Array.from(categoryChoices.passedElement.element.children).length === 0) categoryChoices.setValue(['All Categories'])
          setTimeout(() => {
            // repopulate choices with 'All Categories'
            let array = [];
            let n = 1;
            let obj;
            data.forEach(row => {
              row[1].forEach(item => {
                console.log(item)
                console.log(e.detail.choice.value)
                // if (item.value === e.detail.choice.value ) {
                //   item['disabled'] = true;
                // }
                selectedArray.forEach(currentlyDisabled => {
                  console.log(currentlyDisabled.value, item.value, (currentlyDisabled.value === item.value), (item.value === e.detail.choice.value))

                  if (currentlyDisabled.value === item.value) {
                    console.log('hi')
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
          console.log(data)
        });
    } else if (e.detail.choice.label === 'All Categories') {
      // remove all other categories if all is selected
      categoryChoices._currentState.items.filter(function (item) {
        for (let key in item) {
          if (key === 'label' && item[key] !== 'All Categories') {
            categoryChoices.removeActiveItemsByValue(item.value);
          }
        }
      })
      fetchWithToken( 'http://localhost:3000/api/v1/categories/removed_all', {
        method: "GET",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      })
        .then(response => response.json())
        .then((data) => {
          const selectedArray = categoryChoices.getValue()
          console.log(selectedArray)
          if (Array.from(categoryChoices.passedElement.element.children).length === 0) categoryChoices.setValue(['All Categories'])
          setTimeout(() => {
            // repopulate choices with 'All Categories'
            let array = [];
            let n = 1;
            let obj;
            data.forEach(row => {
              row[1].forEach(item => {
                console.log(item)
                console.log(e.detail.choice.value)
                // if (item.value === e.detail.choice.value ) {
                //   item['disabled'] = true;
                // }
                selectedArray.forEach(currentlyDisabled => {
                  console.log(currentlyDisabled.value, item.value, (currentlyDisabled.value === item.value), (item.value === e.detail.choice.value))

                  if (currentlyDisabled.value === item.value) {
                    console.log('hi')
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
          console.log(data)
        });
    }
  })

  //     fetchWithToken( 'http://localhost:3000/api/v1/categories/enabled_all', {
  //       method: "GET",
  //       headers: {
  //         "Accept": "application/json",
  //         "Content-Type": "application/json"
  //       }
  //     })
  //       .then(response => response.json())
  //       .then((data) => {
  //         console.log(data)
  //         setTimeout(() => {
  //           // add 'All Categories' back to the field
  //           if (Array.from(categoryChoices.passedElement.element.children).length === 0) categoryChoices.setValue(['All Categories'])
  //           // repopulate choices without 'All Categories'
  //           let array = [];
  //           let n = 1;
  //           let obj;
  //           data.forEach(row => {
  //             if (row[0] === 'All') {
  //               obj = {label: row[0], id: n, disabled: true, choices: row[1]}
  //             } else {
  //               obj = {label: row[0], id: n, disabled: false, choices: row[1]}
  //             }
  //             array.push(obj);
  //             n = n + 1
  //           })
  //           categoryChoices.setChoices(array, 'value', 'label', true);
  //         }, 100)
  //       });
  //   }
  // })

  // ensure the categories selector is not empty. There's a delay to avoid this firing if you're selecting another category
    categoryChoices.passedElement.element.addEventListener('removeItem', (e) => {
      console.log('hi')
      fetchWithToken( 'http://localhost:3000/api/v1/categories/removed_all', {
      method: "GET",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      }
    })
      .then(response => response.json())
      .then((data) => {
        const selectedArray = categoryChoices.getValue()
          console.log(selectedArray)
          if (Array.from(categoryChoices.passedElement.element.children).length === 0) categoryChoices.setValue(['All Categories'])
          setTimeout(() => {
            // repopulate choices with 'All Categories'
            let array = [];
            let n = 1;
            let obj;
            data.forEach(row => {
              row[1].forEach(item => {
                console.log(item)
                // if (item.value === e.detail.choice.value ) {
                //   item['disabled'] = true;
                // }
                selectedArray.forEach(currentlyDisabled => {
                  console.log(currentlyDisabled.value, item.value, (currentlyDisabled.value === item.value), (item.value === e.detail.choice.value))

                  if (currentlyDisabled.value === item.value) {
                    console.log('hi')
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
          console.log(data)
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
    maxItemCount: 5,
    searchEnabled: true,
    searchPlaceholderValue: 'Type here to find a tag.',
    classNames: {
      containerOuter: 'choices tag-select'
    }
  });
  return [categoryChoices, languageChoices, tagChoices]
}

export { searchSetup }
