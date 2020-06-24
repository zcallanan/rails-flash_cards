import { Controller } from "stimulus"
import { csrfToken } from "@rails/ujs";
import { fetchWithToken } from '../utils/fetch_with_token.js';
import { isVisible } from '../utils/is_visible.js';

export default class extends Controller {
  static targets = [
    "titleinfo",
    "descriptioninfo",
    "title",
    "description",
    "edit",
    "div",
    "submit"
  ]

  dclick(event) {
    const deckSubmitButton = event.target
    const deckT = this.titleinfoTarget
    const deckDes = this.descriptioninfoTarget
    const deckTField = this.titleTarget
    const deckDesField = this.descriptionTarget
    const deckEditButton = this.editTarget
    const deckDiv = this.divTarget

    setTimeout(function(){
      if (isVisible(deckT) && isVisible(deckDes) && isVisible(deckEditButton)) {
        if (deckDiv.style.display == 'none') {
          deckT.style.display = 'none';
          deckDes.style.display = 'none';
          deckEditButton.style.display = 'none';
          deckDiv.style.display = 'block';
        }
      }
    }, 300);
  }


  dclickout(event) {
    // mousedown event
    const deckSubmitButton = this.submitTarget
    const deckT = this.titleinfoTarget
    const deckDes = this.descriptioninfoTarget
    const deckTField = this.titleTarget
    const deckDesField = this.descriptionTarget
    const deckEditButton = this.editTarget
    const deckDiv = this.divTarget
    const deck_url = `http://localhost:3000/api/v1/decks/${deckSubmitButton.dataset.deck_id}/deck_strings/${deckSubmitButton.dataset.id}`;

    if (!deckDiv.contains(event.target) && isVisible(deckTField) && isVisible(deckDesField)) {
      if (deckDiv.style.display == 'block') {
        deckDiv.style.display = 'none';
        deckDes.style.display = 'block';
        deckT.style.display = 'block';
        deckEditButton.style.display = 'block';
      }
      fetchWithToken(deck_url,
      {
      method: "PATCH",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        deck_string: {
          title: deckTField.value,
          description: deckDesField.value
        }
      })
    })
      .then(response => response.json())
      .then((data) => {
        deckT.innerText = data.title;
        deckDes.innerText = data.description;
        deckSubmitButton.disabled = false;
        if (deckDiv.style.display == 'block') {
          deckDiv.style.display = 'none';
          deckDes.style.display = 'block';
          deckT.style.display = 'block';
          deckEditButton.style.display = 'block';
        }
      });
    }

  }

  dsubmit(event) {
    // form submission
    event.preventDefault();

    const deckSubmitButton = event.target
    const deckT = this.titleinfoTarget
    const deckDes = this.descriptioninfoTarget
    const deckTField = this.titleTarget
    const deckDesField = this.descriptionTarget
    const deckEditButton = this.editTarget
    const deckDiv = this.divTarget
    const deck_url = `http://localhost:3000/api/v1/decks/${deckSubmitButton.dataset.deck_id}/deck_strings/${deckSubmitButton.dataset.id}`;

    fetchWithToken(deck_url, {
      method: "PATCH",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        deck_string: {
          title: deckTField.value,
          description: deckDesField.value
        }
      })
    })
      .then(response => response.json())
      .then((data) => {
        deckT.innerText = data.title;
        deckDes.innerText = data.description;
        deckSubmitButton.disabled = false;
        if (deckDiv.style.display == 'block') {
          deckDiv.style.display = 'none';
          deckDes.style.display = 'block';
          deckT.style.display = 'block';
          deckEditButton.style.display = 'block';
    }
      });
  }
}
