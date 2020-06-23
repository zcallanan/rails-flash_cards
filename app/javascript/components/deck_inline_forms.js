import { csrfToken } from "@rails/ujs";
import { fetchWithToken } from '../utils/fetch_with_token.js';
import { toggleFormInline} from '../utils/toggle_form_inline.js'

// decks
const deckTBool = !!(document.getElementById('deck-title'));
const deckDesBool = !!(document.getElementById('deck-description'));
const form = document.querySelector('.edit_deck_string');
const deckT = document.getElementById('deck-title');
const deckEditButton = document.getElementById('deck-edit-button');
const deckDiv = document.getElementById('deck-inline-form');
const deckTField = document.getElementById('deck_string_title');
const deckSubmitButton = document.getElementById('deck-inline-submit');
const deckDes = document.getElementById('deck-description');
const deckDesDiv = document.getElementById('deck-description-form');
const deckDesField = document.getElementById('deck_string_description');
const deckInit = { title: deckT, description: deckDes, form: deckDiv, submit: deckSubmitButton, edit: deckEditButton }

const deck_url = `http://localhost:3000/api/v1/decks/${deckSubmitButton.dataset.deck_id}/deck_strings/${deckSubmitButton.dataset.id}`;

// deck event listeners
  deckT.addEventListener('click', (e) => toggleFormInline(e, deckInit))
  deckDes.addEventListener('click', (e) => toggleFormInline(e, deckInit))
  deckEditButton.addEventListener('click', (e) => toggleFormInline(e, deckInit))
  document.body.addEventListener('mousedown', (e) => {
    if (!deckDiv.contains(e.target)) {
      if (deckDiv.style.display == 'block') {
        toggleFormInline(e, deckInit)
      }
    }
  });

// ajax
const initInline = () => {
  return {
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
    }
  )}
};

form.addEventListener("submit", (event) => {
  event.preventDefault();

  fetchWithToken(deck_url, initInline())
    .then(response => response.json())
    .then((data) => {
      console.log(data);
      deckT.innerText = data.title;
      deckDes.innerText = data.description;
      deckSubmitButton.disabled = false;
    });
  });

