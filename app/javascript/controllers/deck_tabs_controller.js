import { Controller } from "stimulus"
import { fetchWithToken } from '../utils/fetch_with_token.js';
import { isVisible } from '../utils/is_visible.js';
import { buildSearchUrl } from '../utils/build_search_url.js';

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
    'linkshared',
    'link',
    'list',
    'searchSubmit',
    'nameField',
    'languageField',
    'tagField',
    'option'
  ]

  connect() {
    const globalDiv = this.globalTarget;
    const myDecksDiv = this.mydecksTarget;
    const sharedDiv = this.sharedTarget;
    // const nameField = this.nameFieldTarget;
    const languageField = this.languageFieldTarget;
    const tagField = this.tagFieldTarget;
    const options = this.optionTargets;
    const urlRoute = 'http://localhost:3000/api/v1/decks/';
    let dest = '';
    let searchValues = {}

    if (isVisible(globalDiv)) {
      dest = 'global';
      searchValues['div'] = globalDiv
    } else if (isVisible(myDecksDiv)) {
      dest = 'mydecks';
      searchValues['div'] = myDecksDiv
    } else if (isVisible(sharedDiv)) {
      dest = 'shared'
      searchValues['div'] = sharedDiv
    }

    const search_url = {
      options: options,
      language: languageField.value,
      tag: tagField.value,
      urlRoute: urlRoute,
      dest: dest
    };
    searchValues['url'] = buildSearchUrl(search_url);
    this.search(searchValues);
  }

  tabclick(event) {
    event.preventDefault();

    const globalDiv = this.globalTarget;
    const myDecksDiv = this.mydecksTarget;
    const sharedDiv = this.sharedTarget;
    const listAll = this.listallTarget;
    const listMyDecks = this.listmydecksTarget;
    const listShared = this.listsharedTarget;
    const linkAll = this.linkallTarget;
    const linkMyDecks = this.linkmydecksTarget;
    const linkShared = this.linksharedTarget;
    const searchSubmit = this.searchSubmitTarget;
    // const nameField = this.nameFieldTarget;
    const languageField = this.languageFieldTarget;
    const tagField = this.tagFieldTarget;
    const options = this.optionTargets;
    const urlRoute = 'http://localhost:3000/api/v1/decks/';
    let dest = '';
    let searchValues = {}

    if (event.target === listAll || event.target == linkAll && !listAll.classList.contains('active')) {
      globalDiv.style.display = 'block';
      myDecksDiv.style.display = 'none';
      sharedDiv.style.display = 'none';
      if (listMyDecks.classList.contains('active')) listMyDecks.classList.remove('active')
      if (listShared.classList.contains('active')) listShared.classList.remove('active')
      listAll.classList.add('active');
      const allTabValues = {
        url: 'http://localhost:3000/api/v1/decks/global', // click on the tab and you get all global items available
        div: globalDiv
      }
      this.search(allTabValues)
    } else if ((event.target === listMyDecks || event.target == linkMyDecks) && !listMyDecks.classList.contains('active')) {
      globalDiv.style.display = 'none';
      myDecksDiv.style.display = 'block';
      sharedDiv.style.display = 'none';
      if (listAll.classList.contains('active')) listAll.classList.remove('active')
      if (listShared.classList.contains('active')) listShared.classList.remove('active')
      listMyDecks.classList.add('active');
      const allTabValues = {
        url: 'http://localhost:3000/api/v1/decks/mydecks', // click on the tab and you get all mydeck items available
        div: myDecksDiv
      }
      this.search(allTabValues)
    } else if ((event.target === listShared || event.target == linkShared) && !listShared.classList.contains('active')) {
      globalDiv.style.display = 'none';
      myDecksDiv.style.display = 'none';
      sharedDiv.style.display = 'block';
      if (listAll.classList.contains('active')) listAll.classList.remove('active')
      if (listMyDecks.classList.contains('active')) listMyDecks.classList.remove('active')
      listShared.classList.add('active');
      const allTabValues = {
        url: 'http://localhost:3000/api/v1/decks/shared', // click on the tab and you get all shared items available
        div: sharedDiv
      }
      this.search(allTabValues)
    } else if (event.target === searchSubmit) {
      if (isVisible(globalDiv)) {
        dest = 'global';
        searchValues['div'] = globalDiv;
      } else if (isVisible(myDecksDiv)) {
        dest = 'mydecks';
        searchValues['div'] = myDecksDiv;
      } else if (isVisible(sharedDiv)) {
        dest = 'shared';
        searchValues['div'] = sharedDiv;
      }

      const search_url = {
        options: options,
        language: languageField.value,
        tag: tagField.value,
        urlRoute: urlRoute,
        dest: dest
      };
      searchValues['url'] = buildSearchUrl(search_url);
      this.search(searchValues);
    }
  }

  search(values) {
    fetchWithToken(values.url, {
      method: "GET",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      }
    })
      .then(response => response.json())
      .then((data) => {
        values.div.innerHTML = ''
        values.div.innerHTML = data['data']['partials'].join('')
      });
  }
}
