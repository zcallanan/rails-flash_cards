import { Controller } from "stimulus"
import { inlineStrings } from '../utils/inline_strings.js'

export default class extends Controller {
  static targets = [
    "titleinfo",
    "descriptioninfo",
    "title",
    "description",
    "edit",
    "div",
    "submit",
    "button"
  ]

  dclick(event) {
    console.log('hello')
    const object = {
      submitButton: this.submitTarget,
      button: this.buttonTarget, // if user hits enter in the form
      titleInfo: this.titleinfoTarget,
      descriptionInfo: this.descriptioninfoTarget,
      title: this.titleTarget,
      description: this.descriptionTarget,
      edit: this.editTarget,
      div: this.divTarget,
      url: `http://localhost:3000/api/v1/decks/${this.submitTarget.dataset.deck_id}/deck_strings/${this.submitTarget.dataset.id}`,
      body: {
        deck_string: {
          title: this.titleTarget.value,
          description: this.descriptionTarget.value
        }
      }
    };

    inlineStrings(object);
  }
}
