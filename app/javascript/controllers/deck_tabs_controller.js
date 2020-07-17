import { Controller } from "stimulus"
import { fetchWithToken } from '../utils/fetch_with_token.js';
import { isVisible } from '../utils/is_visible.js';
import { buildSearchUrl } from '../utils/build_search_url.js';
import { searchSetup } from "../utils/search_setup.js"

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
    'categorySelect',
    'languageSelect',
    'tagSelect',
    'option',
    'indexDiv',
    'categorySelect'
  ]

  connect() {

    const globalDiv = this.globalTarget;
    const myDecksDiv = this.mydecksTarget;
    const myArchivedDiv = this.myArchivedTarget;
    const sharedReadDiv = this.sharedReadTarget;
    const sharedUpdateDiv = this.sharedUpdateTarget;
    const categorySelect = this.categorySelectTarget;
    const languageSelect = this.languageSelectTarget;
    const tagSelect = this.tagSelectTarget;
    const listAll = this.listallTarget;
    const listMyDecks = this.listmydecksTarget;
    const listShared = this.listsharedTarget;
    const linkAll = this.linkallTarget;
    const linkMyDecks = this.linkmydecksTarget;
    const linkShared = this.linksharedTarget;
    const searchSubmit = this.searchSubmitTarget;
    const urlRoute = 'http://localhost:3000/api/v1/decks/';
    let dest = '';
    let destTwo = '';
    let divTwo = '';
    let searchValues = {};
    let searchValuesTwo = {}
    const targets = [linkAll, linkMyDecks, linkShared, searchSubmit, listAll, listMyDecks, listShared]
    const [categoryChoices, languageChoices, tagChoices] = searchSetup(categorySelect, languageSelect, tagSelect)
    const tag_options = Array.from(tagSelect.children).map(option => option.value)
    const category_options = Array.from(categorySelect.children).map(option => option.value)

    // ensure the categories selector is not empty. There's a delay to avoid this firing if you're selecting another category
    categoryChoices.passedElement.element.addEventListener('removeItem', () => {
      setTimeout(() => {
        if (Array.from(categoryChoices.passedElement.element.children).length === 0) categoryChoices.setValue(['All Categories'])
      }, 100)

    })

    if (isVisible(globalDiv)) {
      dest = 'global';
      searchValues['div'] = globalDiv
      destTwo = null;
    } else if (isVisible(myDecksDiv)) {
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
      options: category_options,
      language: languageSelect.value,
      tag: tag_options,
      urlRoute: urlRoute,
      dest: dest
    };

    searchValues['url'] = buildSearchUrl(search_url);
    this.search(searchValues);

    if (destTwo !== null) {
      search_url = {
        options: category_options,
        language: languageSelect.value,
        tag: tag_options,
        urlRoute: urlRoute,
        dest: destTwo
      };
      searchValuesTwo['div'] = divTwo;
      searchValuesTwo['url'] = buildSearchUrl(search_url);
      this.search(searchValuesTwo);
    }

    targets.forEach((target) => {
      target.addEventListener('click', (event) => {
        event.preventDefault();
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

          const tag_options = Array.from(tagSelect.children).map(option => option.value)
          const category_options = Array.from(categorySelect.children).map(option => option.value)

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
            options: category_options,
            language: languageSelect.value,
            tag: tag_options,
            urlRoute: urlRoute,
            dest: dest
          };

          searchValues['url'] = buildSearchUrl(search_url);
          console.log(searchValues)
          this.search(searchValues);

          if (destTwo !== null) {
            const tag_options = Array.from(tagSelect.children).map(option => option.value)
            const category_options = Array.from(categorySelect.children).map(option => option.value)
            search_url = {
              options: category_options,
              language: languageSelect.value,
              tag: tag_options,
              urlRoute: urlRoute,
              dest: destTwo
            };
            searchValuesTwo['div'] = divTwo;
            searchValuesTwo['url'] = buildSearchUrl(search_url);
            console.log(searchValuesTwo)
            this.search(searchValuesTwo);
          }
        }
      })
    })
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
        console.log(values.div)
        values.div.innerHTML = ''
        values.div.innerHTML = data['data']['partials'].join('')
      });
  }
}


