import { Controller } from "stimulus"
import { csrfToken } from "@rails/ujs";
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

    const object = {
      submitbutton: this.submitTarget,
      button: this.buttonTarget, // if user hits enter in the form
      titleinfo: this.titleinfoTarget,
      descriptioninfo: this.descriptioninfoTarget,
      title: this.titleTarget,
      description: this.descriptionTarget,
      edit: this.editTarget,
      div: this.divTarget
    };

    inlineStrings(object);
  }
}
