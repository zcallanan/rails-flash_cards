// As a user I can add any tag that exists to my content, across all decks
// It's saved to a tag_set

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "tagField" ]

  connect() {
    const tagField = this.tagFieldTarget;
    let picker = new TP(tagField, { x: true });
    picker.input.setAttribute('data-target', 'tags.editor')
    picker.input.setAttribute('data-action', 'keyup->tags#change change->tags#change')
  }

  change(event) {
    console.log(event.target.innerText)

  }
}
