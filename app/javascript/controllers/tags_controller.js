// As a user I can add any tag that exists to my content, across all decks
// It's saved to a tag_set

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'tagField', 'suggestions' ]

  connect() {
    const tagField = this.tagFieldTarget;
    let picker = new TP(tagField, { x: true });
    picker.input.setAttribute('data-action', 'keyup->tags#change change->tags#change')

  }

  change(event) { // tag editor field fires change or keyup events
    const suggestions = this.suggestionsTarget;
    const editor = event.target;
    const editorText = editor.innerHTML.toLowerCase()
    const endpoint = 'http://localhost:3000/api/v1/tags';
    const tags = []
    for (let key in TP.instances) {
      const picker = TP.instances[key] // get the tag picker object to adjust the tag array
      const allTags = picker.tags

      const findMatches = (editorText, tags) => {
        tags.forEach(tag => { // remove tags that have already been added from typeahead results
          if (allTags.includes(tag.name)) {
            let index = tags.indexOf(tag)
            tags.splice(index, 1)
          }
        })
        return tags.filter(tag => { // filter tags for string partials that match editor's text, return full string
          const regex = new RegExp(editorText, 'gi');
          return tag.name.match(regex)
        });
      }

      const displayMatches = (editorText, tags) => {
        const matchArray = findMatches(editorText, tags)
        const html = matchArray.map(tag => {
          const regex = new RegExp(editorText, 'gi')
          const tagName = tag.name.replace(regex, `<span class="hl">${editorText}</span>`) // highlight matching partial in string
          return `<li class="suggested-tag" data-action="click->tags#select">
              <span class="tag-name">${tagName}</span>
            </li>`
        }).join('');
        suggestions.innerHTML = html;
      }
      if (editorText !== '') {
        fetch(endpoint)
        .then(blob => blob.json())
        .then(data => {
          tags.push(...data);
          displayMatches(editorText, tags);
        })
      } else {
          suggestions.innerHTML = ''; // if there's nothing in the editor field, remove the typeahead html
      }
    }
  }

  select(event) { // typeahead list element selected
    const suggestedText = event.target.innerText
    const suggestions = this.suggestionsTarget;
    for (let key in TP.instances) {
      const picker = TP.instances[key] // get the tag picker object to adjust the tag array
      const allTags = picker.tags
      picker.let(allTags[allTags.length - 1]) // remove the fragment tag if you are selecting a typeahead value
      picker.set(suggestedText) // add typeahead value as a tag
    }
    suggestions.innerHTML = ''; // remove the typeahead html after selection
  }
}
