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

  cclick(event) {
    const collSubmitButton = event.target
    const collT = this.titleinfoTarget
    const collDes = this.descriptioninfoTarget
    const collTField = this.titleTarget
    const collDesField = this.descriptionTarget
    const collEditButton = this.editTarget
    const collDiv = this.divTarget

    setTimeout(function(){
      if (isVisible(collT) && isVisible(collDes) && isVisible(collEditButton)) {
        if (collDiv.style.display == 'none') {
          collT.style.display = 'none';
          collDes.style.display = 'none';
          collEditButton.style.display = 'none';
          collDiv.style.display = 'block';
        }
      }
    }, 300);
  }


  cclickout(event) {
    // mousedown event
    const collSubmitButton = this.submitTarget
    const collT = this.titleinfoTarget
    const collDes = this.descriptioninfoTarget
    const collTField = this.titleTarget
    const collDesField = this.descriptionTarget
    const collEditButton = this.editTarget
    const collDiv = this.divTarget
    const coll_url = `http://localhost:3000/api/v1/colls/${collSubmitButton.dataset.coll_id}/coll_strings/${collSubmitButton.dataset.id}`;

    if (!collDiv.contains(event.target) && isVisible(collTField) && isVisible(collDesField)) {
      if (collDiv.style.display == 'block') {
        collDiv.style.display = 'none';
        collDes.style.display = 'block';
        collT.style.display = 'block';
        collEditButton.style.display = 'block';
      }
      fetchWithToken(coll_url,
      {
      method: "PATCH",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        coll_string: {
          title: collTField.value,
          description: collDesField.value
        }
      })
    })
      .then(response => response.json())
      .then((data) => {
        collT.innerText = data.title;
        collDes.innerText = data.description;
        collSubmitButton.disabled = false;
        if (collDiv.style.display == 'block') {
          collDiv.style.display = 'none';
          collDes.style.display = 'block';
          collT.style.display = 'block';
          collEditButton.style.display = 'block';
        }
      });
    }

  }

  csubmit(event) {
    // form submission
    event.preventDefault();

    const collSubmitButton = event.target
    const collT = this.titleinfoTarget
    const collDes = this.descriptioninfoTarget
    const collTField = this.titleTarget
    const collDesField = this.descriptionTarget
    const collEditButton = this.editTarget
    const collDiv = this.divTarget
    const coll_url = `http://localhost:3000/api/v1/colls/${collSubmitButton.dataset.coll_id}/coll_strings/${collSubmitButton.dataset.id}`;

    fetchWithToken(coll_url, {
      method: "PATCH",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        coll_string: {
          title: collTField.value,
          description: collDesField.value
        }
      })
    })
      .then(response => response.json())
      .then((data) => {
        collT.innerText = data.title;
        collDes.innerText = data.description;
        collSubmitButton.disabled = false;
        if (collDiv.style.display == 'block') {
          collDiv.style.display = 'none';
          collDes.style.display = 'block';
          collT.style.display = 'block';
          collEditButton.style.display = 'block';
    }
      });
  }
}
