import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'nav',
    'searchPanel',
    'deckList',
    'deckCreate'
  ]

  fixNav() {
    const index_nav = this.navTarget;
    const searchPanel = this.searchPanelTarget;
    const deckList = this.deckListTarget;
    const deckCreate = this.deckCreateTarget;
    const navHeight = index_nav.getBoundingClientRect().height;

    if (index_nav.dataset.topNav !== undefined) {
      const topOfNav = index_nav.dataset.topNav;
      if (window.scrollY >= topOfNav) {
        document.body.classList.add('fixed-nav');
        searchPanel.style.paddingTop = navHeight + 'px';  // stop side panel from jumping down when the nav is fixed
        deckList.style.paddingTop = navHeight + 'px'; // stop deck panel/top bar from jumping up when the nav is fixed
        deckCreate.style.paddingTop = navHeight + 'px';
      } else {
        document.body.classList.remove('fixed-nav');
        searchPanel.style.paddingTop = 0;
        deckCreate.style.paddingTop = 0;
        deckList.style.paddingTop = 0;
      }
    } else {
      index_nav.dataset.topNav = index_nav.offsetTop;
    }
  }
}
