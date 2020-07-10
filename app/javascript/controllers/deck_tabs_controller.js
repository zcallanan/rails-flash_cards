import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'global',
    'mydecks',
    'shared',
    'listall',
    'listmydecks',
    'listshared',
    'linkall',
    'linkmydecks',
    'linkshared'
  ]

  tabclick(event) {
    event.preventDefault();

    const global_div = this.globalTarget;
    const mydecks_div = this.mydecksTarget;
    const shared_div = this.sharedTarget;
    const list_all = this.listallTarget;
    const list_my_decks = this.listmydecksTarget;
    const list_shared = this.listsharedTarget;
    const linkall = this.linkallTarget;
    const linkmydecks = this.linkmydecksTarget;
    const linkshared = this.linksharedTarget;

    if ((event.target == list_all || event.target == linkall) && !list_all.classList.contains('active')) {
      global_div.style.display = 'block';
      mydecks_div.style.display = 'none';
      shared_div.style.display = 'none';
      if (list_my_decks.classList.contains('active')) list_my_decks.classList.remove('active')
      if (list_shared.classList.contains('active')) list_shared.classList.remove('active')
      list_all.classList.add('active');
      const url = `http://localhost:3000/api/v1/decks/global`
      this.search(url)
    } else if ((event.target == list_my_decks || event.target == linkmydecks) && !list_my_decks.classList.contains('active')) {
      global_div.style.display = 'none';
      mydecks_div.style.display = 'block';
      shared_div.style.display = 'none';
      if (list_all.classList.contains('active')) list_all.classList.remove('active')
      if (list_shared.classList.contains('active')) list_shared.classList.remove('active')
      list_my_decks.classList.add('active');
    } else if ((event.target == list_shared || event.target == linkshared) && !list_shared.classList.contains('active')) {
      global_div.style.display = 'none';
      mydecks_div.style.display = 'none';
      shared_div.style.display = 'block';
      if (list_all.classList.contains('active')) list_all.classList.remove('active')
      if (list_my_decks.classList.contains('active')) list_my_decks.classList.remove('active')
      list_shared.classList.add('active');
    }
  }

  search(url) {
    fetchWithToken(url, {
      method: "GET",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      }
    })
      .then(response => response.json())
      .then((data) => {
        console.log(data)
      });
  }
}
