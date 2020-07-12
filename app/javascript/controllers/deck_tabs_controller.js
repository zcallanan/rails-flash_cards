import { Controller } from "stimulus"
import { fetchWithToken } from '../utils/fetch_with_token.js';
import { isVisible } from '../utils/is_visible.js';
import { buildSearchUrl } from '../utils/build_search_url.js';

export default class extends Controller {
  static targets = [
    'global',
    'mydecks',
    'myArchived',
    'sharedRead',
    'sharedUpdate',
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
    'option',
    'indexDiv'
  ]

  connect() {

    const globalDiv = this.globalTarget;
    const myDecksDiv = this.mydecksTarget;
    const myArchivedDiv = this.myArchivedTarget;
    const sharedReadDiv = this.sharedReadTarget;
    const sharedUpdateDiv = this.sharedUpdateTarget;
    const languageField = this.languageFieldTarget;
    const tagField = this.tagFieldTarget;
    const options = this.optionTargets;
    const urlRoute = 'http://localhost:3000/api/v1/decks/';
    let dest = '';
    let destTwo = '';
    let divTwo = '';
    let searchValues = {};

    if (isVisible(globalDiv)) {
      console.log('yo')
      dest = 'global';
      searchValues['div'] = globalDiv
      destTwo = null;
    } else if (isVisible(myDecksDiv)) {
      console.log('hi')
      dest = 'mydecks';
      searchValues['div'] = myDecksDiv
      destTwo = 'myarchived';
      divTwo = myArchivedDiv;
    } else if (isVisible(sharedReadDiv)) {
      dest = 'shared_read'
      searchValues['div'] = sharedReadDiv
      destTwo = 'shared_update';
      divTwo = sharedUpdateDiv;
    }

    let search_url = {
      options: options,
      language: languageField.value,
      tag: tagField.value,
      urlRoute: urlRoute,
      dest: dest
    };
    searchValues['url'] = buildSearchUrl(search_url);
    console.log(searchValues)
    this.search(searchValues);

    if (destTwo !== null) {
      search_url = {
        options: options,
        language: languageField.value,
        tag: tagField.value,
        urlRoute: urlRoute,
        dest: destTwo
      };
      searchValues['div'] = divTwo;
      searchValues['url'] = buildSearchUrl(search_url);
      this.search(searchValues);
    }
  }

  tabclick(event) {
    event.preventDefault();

    const globalDiv = this.globalTarget;
    const myDecksDiv = this.mydecksTarget;
    const myArchivedDiv = this.myArchivedTarget;
    const sharedReadDiv = this.sharedReadTarget;
    const sharedUpdateDiv = this.sharedUpdateTarget;
    const listAll = this.listallTarget;
    const listMyDecks = this.listmydecksTarget;
    const listShared = this.listsharedTarget;
    const linkAll = this.linkallTarget;
    const linkMyDecks = this.linkmydecksTarget;
    const linkShared = this.linksharedTarget;
    const searchSubmit = this.searchSubmitTarget;
    const languageField = this.languageFieldTarget;
    const tagField = this.tagFieldTarget;
    const options = this.optionTargets;
    const urlRoute = 'http://localhost:3000/api/v1/decks/';
    let dest = '';
    let destTwo = ''
    let divTwo = ''
    let searchValues = {}

    if (event.target === listAll || event.target == linkAll && !listAll.classList.contains('active')) {
      globalDiv.style.display = 'block';
      myDecksDiv.style.display = 'none';
      myArchivedDiv.style.display = 'none';
      sharedReadDiv.style.display = 'none';
      sharedUpdateDiv.style.display = 'none';
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
      myArchivedDiv.style.display = 'block';
      sharedReadDiv.style.display = 'none';
      sharedUpdateDiv.style.display = 'none';
      if (listAll.classList.contains('active')) listAll.classList.remove('active')
      if (listShared.classList.contains('active')) listShared.classList.remove('active')
      listMyDecks.classList.add('active');
      let allTabValues = {
        url: 'http://localhost:3000/api/v1/decks/mydecks', // click on the tab and you get all mydeck items available
        div: myDecksDiv
      }
      this.search(allTabValues)
      allTabValues = {
        url: 'http://localhost:3000/api/v1/decks/myarchived',
        div: myArchivedDiv
      }
      this.search(allTabValues)
    } else if ((event.target === listShared || event.target == linkShared) && !listShared.classList.contains('active')) {
      globalDiv.style.display = 'none';
      myDecksDiv.style.display = 'none';
      myArchivedDiv.style.display = 'none';
      sharedReadDiv.style.display = 'block';
      sharedUpdateDiv.style.display = 'block';
      if (listAll.classList.contains('active')) listAll.classList.remove('active')
      if (listMyDecks.classList.contains('active')) listMyDecks.classList.remove('active')
      listShared.classList.add('active');
      let allTabValues = {
        url: 'http://localhost:3000/api/v1/decks/shared_read', // click on the tab and you get all shared items available
        div: sharedReadDiv
      }
      this.search(allTabValues)
      allTabValues = {
        url: 'http://localhost:3000/api/v1/decks/shared_update',
        div: sharedUpdateDiv
      }
      this.search(allTabValues)
    } else if (event.target === searchSubmit) {
      if (isVisible(globalDiv)) {
        dest = 'global';
        searchValues['div'] = globalDiv;
        destTwo = null;
      } else if (isVisible(myDecksDiv)) {
        dest = 'mydecks';
        searchValues['div'] = myDecksDiv;
        destTwo = 'myarchived';
        divTwo = myArchivedDiv;
      } else if (isVisible(sharedReadDiv)) {
        dest = 'shared_read';
        searchValues['div'] = sharedReadDiv;
        destTwo = 'shared_update';
        divTwo = sharedUpdateDiv;
      }

      let search_url = {
        options: options,
        language: languageField.value,
        tag: tagField.value,
        urlRoute: urlRoute,
        dest: dest
      };
      searchValues['url'] = buildSearchUrl(search_url);
      this.search(searchValues);

      if (destTwo !== null) {
        search_url = {
          options: options,
          language: languageField.value,
          tag: tagField.value,
          urlRoute: urlRoute,
          dest: destTwo
        };
        searchValues['div'] = divTwo;
        searchValues['url'] = buildSearchUrl(search_url);
        this.search(searchValues);
      }
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
