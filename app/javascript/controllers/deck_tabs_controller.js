import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'alltab',
    'mytab',
    'sharedtab',
    'global',
    'mydecks',
    'shared',
    'listall',
    'listmydecks',
    'listshared'
  ]

  tabclick(event) {
    const alltab = this.alltabTarget;
    const mytab = this.mytabTarget;
    const sharedtab = this.sharedtabTarget;
    const global_div = this.globalTarget;
    const mydecks_div = this.mydecksTarget;
    const shared_div = this.sharedTarget;
    const list_all = this.listallTarget;
    const list_my_decks = this.listmydecksTarget;
    const list_shared = this.listsharedTarget;
    console.log(list_all.classList)

    if (event.target == list_all && !list_all.classList.contains('active')) {
      global_div.style.display = 'block';
      mydecks_div.style.display = 'none';
      shared_div.style.display = 'none';
      if (list_my_decks.classList.contains('active')) list_my_decks.classList.remove('active')
      if (list_shared.classList.contains('active')) list_shared.classList.remove('active')
      list_all.classList.add('active');
    } else if (event.target == list_my_decks && !list_my_decks.classList.contains('active')) {
      global_div.style.display = 'none';
      mydecks_div.style.display = 'block';
      shared_div.style.display = 'none';
      if (list_all.classList.contains('active')) list_all.classList.remove('active')
      if (list_shared.classList.contains('active')) list_shared.classList.remove('active')
      list_my_decks.classList.add('active');
    } else if (event.target == list_shared && !list_shared.classList.contains('active')) {
      global_div.style.display = 'none';
      mydecks_div.style.display = 'none';
      shared_div.style.display = 'block';
      if (list_all.classList.contains('active')) list_all.classList.remove('active')
      if (list_my_decks.classList.contains('active')) list_my_decks.classList.remove('active')
      list_shared.classList.add('active');
    }
  }
}
