import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'nav',
    'panel'
  ]

  fixNav() {
    const index_nav = this.navTarget;
    const panel = this.panelTarget;
    const navHeight = index_nav.getBoundingClientRect().height;

    if (index_nav.dataset.topNav !== undefined) {
      const topOfNav = index_nav.dataset.topNav;
      if (window.scrollY >= topOfNav) {
        document.body.classList.add('fixed-nav');
        panel.classList.add('search-side-panel');
        panel.style.marginTop = -navHeight + 'px';
      } else {
        document.body.classList.remove('fixed-nav');
        panel.classList.remove('search-side-panel');
        panel.style.marginTop = 0;
      }
    } else {
      index_nav.dataset.topNav = index_nav.offsetTop;
    }
  }
}
