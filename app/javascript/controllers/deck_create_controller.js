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

    const index_button = this.indexbuttonTarget;
    const index_link = this.indexlinkTarget;
    const deck_create_div = this.deckcreatedivTarget;
    const top_bar_div = this.topbardivTarget;
    const cancel = this.cancelTarget;
    const all_decks_tab = this.listallTarget;
    const shared_decks_tab = this.listsharedTarget;
    const all_link = this.linkallTarget;
    const shared_link = this.linksharedTarget;

    if (isVisible(top_bar_div) && !isVisible(deck_create_div) && (event.target === index_button || event.target === index_link || event.target === document)) {
      deck_create_div.style.display = 'block';
      top_bar_div.style.display = 'none';
    } else if (!isVisible(top_bar_div) && isVisible(deck_create_div) && (event.target === cancel || event.target === all_decks_tab || event.target === shared_decks_tab || event.target === all_link || event.target === shared_link)) {
      deck_create_div.style.display = 'none';
      top_bar_div.style.display = 'block';
    }
  }

  click(event) {
    this.createdeck(event)
  }
}
