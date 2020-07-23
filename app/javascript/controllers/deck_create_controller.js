import { isVisible } from '../utils/is_visible.js';
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'createDeckInput',
    'deckSearchInput',
    'deckCreateDiv',
    'deckSearchDiv',
    'cancelButton'
  ]

  toggleSearchCreate(e) {
    e.preventDefault();

    const createDeckInput = this.createDeckInputTarget;
    const deckSearchInput = this.deckSearchInputTarget;
    const deckCreateDiv = this.deckCreateDivTarget;
    const deckSearchDiv = this.deckSearchDivTarget;
    const cancelButton = this.cancelButtonTarget;

    if (e.target === createDeckInput && !isVisible(deckCreateDiv)) {
      deckCreateDiv.style.display = 'block';
      deckSearchDiv.style.display = 'none';
    } else if (e.target === deckSearchInput || (e.target === cancelButton) && !isVisible(deckSearchDiv)) {
      deckCreateDiv.style.display = 'none';
      deckSearchDiv.style.display = 'block';
    }

  }
}
