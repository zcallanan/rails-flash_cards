import { Controller } from "stimulus"
import Choices from "choices.js"

export default class extends Controller {
  static targets = [ 'all', 'option', 'select' ]

  connect() {
    const all = this.allTarget;
    console.log(all)
    const select = this.selectTarget;
    console.log(select.children[0].innerText);

    const choices = new Choices(select, {
      removeItemButton: true,
      classNames: {
        containerOuter: 'choices category-select'
      },
      callbackOnCreateTemplates: function(template) {
        return {
          choice: (classNames, data) => {
            return template(`
              <div class="${classNames.item} ${classNames.itemChoice} ${
              data.disabled ? classNames.itemDisabled : classNames.itemSelectable
            }" data-select-text="${this.config.itemSelectText}" data-choice ${
              data.disabled
                ? 'data-choice-disabled aria-disabled="true"'
                : 'data-choice-selectable'
            } data-id="${data.id}"
             ${
              data.label === "All Categories"
                ? 'data-target="category-select.all"'
                : 'data-target="category-select.option"'
            }
            data-action="click->category-select#options"
            data-value="${data.value}" ${
              data.groupId > 0 ? 'role="treeitem"' : 'role="option"'
            }>
               ${data.label}
              </div>
            `);
          },
        };
      },
    });
    choices.passedElement.element.addEventListener('choice', function(e) {
      if (e.detail.choice.label !== 'All Categories') {
        // remove all categories if you select a specific category
        choices._currentState.items.filter(function (item) {
          for (let key in item) {
            if (key === 'label' && item[key] === 'All Categories') {
              choices.removeActiveItemsByValue(item.value);
            }
          }
        })
      } else if (e.detail.choice.label === 'All Categories') {
        // remove all other categories if all is selected
        choices._currentState.items.filter(function (item) {
          for (let key in item) {
            if (key === 'label' && item[key] !== 'All Categories') {
              choices.removeActiveItemsByValue(item.value);
            }
          }
        })
      }
    })
  }


  itemAdded(event) {
    console.log('best')
  }

  options(event) {
    // prevents scenario where you could search for the All category in addition to a specific category
    console.log(event)
    const allOption = this.allTarget;
    console.log(allOption)
    const otherOptions = this.optionTargets
    const select = this.selectTarget;

    const choices = new Choices(select)
    console.log(select)


    if (event.target === allOption) {
      otherOptions.forEach(option => { if (option.selected === true) option.selected = false })
    } else if (otherOptions.includes(event.target)) {
      if (allOption.selected === true) allOption.selected = false
    }
  }
}
