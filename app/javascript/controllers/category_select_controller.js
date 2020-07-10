import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'all', 'option' ]

  options(event) {
    // prevents scenario where you could search for the All category in addition to a specific category
    const allOption = this.allTarget;
    const otherOptions = this.optionTargets

    if (event.target === allOption) {
      otherOptions.forEach(option => { if (option.selected === true) option.selected = false })
    } else if (otherOptions.includes(event.target)) {
      if (allOption.selected === true) allOption.selected = false
    }
  }
}
