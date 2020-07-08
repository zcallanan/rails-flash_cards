import { isVisible } from '../utils/is_visible.js';
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'indexbutton',
    'indexlink',
    'deckcreatediv',
    'topbardiv',
    'cancel'
  ]

  createdeck(event) {
    event.preventDefault();

    const index_button = this.indexbuttonTarget;
    const index_link = this.indexlinkTarget;
    const deck_create_div = this.deckcreatedivTarget;
    const top_bar_div = this.topbardivTarget;
    const cancel = this.cancelTarget;

    if (isVisible(top_bar_div) && !isVisible(deck_create_div) && (event.target == index_button || event.target == index_link)) {
      deck_create_div.style.display = 'block';
      top_bar_div.style.display = 'none';
    } else if (!isVisible(top_bar_div) && isVisible(deck_create_div) && event.target == cancel) {
      deck_create_div.style.display = 'none';
      top_bar_div.style.display = 'block';
    }

  }
}
