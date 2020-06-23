import { csrfToken } from "@rails/ujs";
import { fetchWithToken } from '../utils/fetch_with_token.js';
import { toggleFormInline} from '../utils/toggle_form_inline.js'

// collections
const collTBool = !!(document.getElementById('collection-title'));
const collDesBool = !!(document.getElementById('collection-description'));
const collT = document.getElementById('collection-title')
const collTEditButton = document.getElementById('collection-edit-button')
const collTForm = document.getElementById('collection-title-form')
const collTSubmitButton = document.getElementById('collection-title-submit')
const collDes = document.getElementById('collection-description')
const collDesEditButton = document.getElementById('collection-des-edit-button')
const collDesForm = document.getElementById('collection-description-form')
const collDesSubmitButton = document.getElementById('collection-description-submit')
const collTInit = { string: collT, form: collTForm, submit: collTSubmitButton, edit: collTEditButton }
const collDesInit = { string: collDes, form: collDesForm, submit: collDesSubmitButton, edit: collDesEditButton }
if (collTBool) {
  const collection_url = `http://localhost:3000/api/v1/collections/${collTSubmitButton.dataset.collection_id}/collection_strings/${collTSubmitButton.dataset.id}`;
}

// collection event listeners
if (collTBool && collDesBool) {
  collT.addEventListener('click', (e) => toggleFormInline(e, collTInit));
  collTEditButton.addEventListener('click', (e) => toggleFormInline(e, collTInit));
  collDes.addEventListener('click', (e) => toggleFormInline(e, collDesInit));
  collDesEditButton.addEventListener('click', (e) => toggleFormInline(e, collDesInit));
  document.body.addEventListener('mousedown', (e) => {
      if (!collTForm.contains(e.target) && !collDesForm.contains(e.target)) {
        if (collTForm.style.display == 'block') {
          toggleFormInline(e, collTInit)
        } else if (collDesForm.style.display == 'block') {
          toggleFormInline(e, collDesInit)
        }
      }
    });
};

// export {toggleFormInline}
