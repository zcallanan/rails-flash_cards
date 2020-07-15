import { Controller } from "stimulus"
import Choices from "choices.js"

export default class extends Controller {
  static targets = [ 'select' ]

  connect() {
    const select = this.selectTarget;

    const choices = new Choices(select, {
      removeItemButton: true,
      classNames: {
        containerOuter: 'choices category-select'
      }
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
}
