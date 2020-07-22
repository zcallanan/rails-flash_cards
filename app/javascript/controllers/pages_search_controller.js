import { Controller } from "stimulus"
import { searchSetup } from "../utils/search_setup.js"

export default class extends Controller {
  static targets = [
  'categorySelect',
  'languageSelect',
  'tagSelect',
  'searchForm'
  ]

  connect() {
    // initializes langing page Choices.js fields
    const categorySelect = this.categorySelectTarget;
    const languageSelect = this.languageSelectTarget;
    const tagSelect = this.tagSelectTarget;
    const searchForm = this.searchFormTarget;

    const [categoryChoices, languageChoices, tagChoices] = searchSetup(categorySelect, languageSelect, tagSelect, searchForm.dataset.con)
    // ensure the categories selector is not empty. There's a delay to avoid this firing if you're selecting another category
    categoryChoices.passedElement.element.addEventListener('removeItem', () => {
      setTimeout(() => {
        if (Array.from(categoryChoices.passedElement.element.children).length === 0) categoryChoices.setValue(['All Categories'])
      }, 100)

    })
  }
}
