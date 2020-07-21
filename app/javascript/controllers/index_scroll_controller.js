import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'nav',
    'panel',
    'deckList'
  ]

  fixNav() {
    const index_nav = this.navTarget;
    const panel = this.panelTarget;
    const deckList = this.deckListTarget;
    const navHeight = index_nav.getBoundingClientRect().height;

    if (index_nav.dataset.topNav !== undefined) {
      const topOfNav = index_nav.dataset.topNav;
      if (window.scrollY >= topOfNav) {
        document.body.classList.add('fixed-nav');
        panel.classList.add('search-side-panel');
        panel.style.marginTop = -navHeight + 'px';  // stop side panel from jumping down when the nav is fixed
        deckList.style.paddingTop = navHeight + 'px'; // stop deck panel/top bar from jumping up when the nav is fixed
      } else {
        document.body.classList.remove('fixed-nav');
        panel.classList.remove('search-side-panel');
        panel.style.marginTop = 0;
        deckList.style.paddingTop = 0;
      }
    } else {
      index_nav.dataset.topNav = index_nav.offsetTop;
    }
  }
}
