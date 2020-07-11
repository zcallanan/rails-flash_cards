import { isVisible } from '../utils/is_visible.js';
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'indexbutton',
    'indexlink',
    'deckcreatediv',
    'topbardiv',
    'cancel',
    'listall',
    'listshared',
    'linkall',
    'linkshared'
  ]

  createdeck(event) {
    event.preventDefault();

    const indexButton = this.indexbuttonTarget;
    const indexLink = this.indexlinkTarget;
    const deckCreateDiv = this.deckcreatedivTarget;
    const topBarDiv = this.topbardivTarget;
    const cancel = this.cancelTarget;
    const allDecksTab = this.listallTarget;
    const sharedDecksTab = this.listsharedTarget;
    const allLink = this.linkallTarget;
    const sharedLink = this.linksharedTarget;

    if (isVisible(topBarDiv) && !isVisible(deckCreateDiv) && (event.target === indexButton || event.target === indexLink || event.target === document)) {
      deckCreateDiv.style.display = 'block';
      topBarDiv.style.display = 'none';
    } else if (!isVisible(topBarDiv) && isVisible(deckCreateDiv) && (event.target === cancel || event.target === allDecksTab || event.target === sharedDecksTab || event.target === allLink || event.target === sharedLink)) {
      deckCreateDiv.style.display = 'none';
      topBarDiv.style.display = 'block';
    }
  }

  click(event) {
    this.createdeck(event)
  }
}
