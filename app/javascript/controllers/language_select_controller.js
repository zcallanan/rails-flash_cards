import { Controller } from "stimulus"
import Choices from "choices.js"

export default class extends Controller {
  static targets = [ "element" ]

  connect() {
    const element = this.elementTarget;
    const choices = new Choices(element, {
      classNames: {
        containerOuter: 'choices language-select'
      },
      searchEnabled: true,
      searchPlaceholderValue: 'Type here to find a language.'
    });
  }
}
