import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "nav" ]

  fixNav() {
    const index_nav = this.navTarget
    if (index_nav.dataset.topNav !== undefined) {
      const topOfNav = index_nav.dataset.topNav
      if (window.scrollY >= topOfNav) {
        document.body.classList.add('fixed-nav');
      } else {
        document.body.classList.remove('fixed-nav');
      }
    } else {
      index_nav.dataset.topNav = index_nav.offsetTop;
    }
  }
}
