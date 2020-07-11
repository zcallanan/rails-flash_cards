import { fetchWithToken } from '../utils/fetch_with_token.js';
import { isVisible } from '../utils/is_visible.js';

const inlineStrings = (object) => {
  if ((object.titleInfo.contains(event.target) || object.descriptionInfo.contains(event.target) || object.edit.contains(event.target))
    && isVisible(object.titleInfo) && isVisible(object.descriptionInfo) && isVisible(object.edit)) {
    setTimeout(function(){
      if (object.div.style.display == 'none') {
        object.titleInfo.style.display = 'none';
        object.descriptionInfo.style.display = 'none';
        object.edit.style.display = 'none';
        object.div.style.display = 'block';
      }
    }, 200);
  }
  else if ((!object.div.contains(event.target) || (object.submitButton == event.target) || (object.button == event.target)) && (isVisible(object.title) && isVisible(object.description))) {
    event.preventDefault();
    fetchWithToken(object.url, {
      method: "PATCH",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify(
        object.body
      )
    })
      .then(response => response.json())
      .then((data) => {
        object.titleInfo.innerText = data.title;
        object.descriptionInfo.innerText = data.description;
        object.button.disabled = false;
        if (object.div.style.display == 'block') {
          object.div.style.display = 'none';
          object.descriptionInfo.style.display = 'block';
          object.titleInfo.style.display = 'block';
          object.edit.style.display = 'block';
        }
      });
  }
}

export { inlineStrings }
