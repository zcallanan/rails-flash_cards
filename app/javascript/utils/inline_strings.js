import { fetchWithToken } from '../utils/fetch_with_token.js';
import { isVisible } from '../utils/is_visible.js';

const inlineStrings = (object) => {
  if (isVisible(object.titleinfo) && isVisible(object.descriptioninfo) && isVisible(object.edit)) {
    setTimeout(function(){
      if (object.div.style.display == 'none') {
        object.titleinfo.style.display = 'none';
        object.descriptioninfo.style.display = 'none';
        object.edit.style.display = 'none';
        object.div.style.display = 'block';
      }
    }, 300);
  }
  else if ((!object.div.contains(event.target) || (object.submitbutton == event.target) || (object.button == event.target)) && (isVisible(object.title) && isVisible(object.description))) {
    const url = `http://localhost:3000/api/v1/decks/${object.submitbutton.dataset.deck_id}/deck_strings/${object.submitbutton.dataset.id}`;
    event.preventDefault();
    fetchWithToken(url, {
      method: "PATCH",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        deck_string: {
          title: object.title.value,
          description: object.description.value
        }
      })
    })
      .then(response => response.json())
      .then((data) => {
        object.titleinfo.innerText = data.title;
        object.descriptioninfo.innerText = data.description;
        object.button.disabled = false;
        if (object.div.style.display == 'block') {
          object.div.style.display = 'none';
          object.descriptioninfo.style.display = 'block';
          object.titleinfo.style.display = 'block';
          object.edit.style.display = 'block';
        }
      });
  }
}

export { inlineStrings }
