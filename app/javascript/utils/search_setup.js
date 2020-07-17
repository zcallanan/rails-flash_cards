import Choices from "choices.js"

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
    } else if (e.detail.choice.label === 'All Categories') {
      // remove all other categories if all is selected
      categoryChoices._currentState.items.filter(function (item) {
        for (let key in item) {
          if (key === 'label' && item[key] !== 'All Categories') {
            categoryChoices.removeActiveItemsByValue(item.value);
          }
        }
      })
    }
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
