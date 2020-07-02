import { fetchWithToken } from '../utils/fetch_with_token.js';
import { isVisible } from '../utils/is_visible.js';

const inlineStrings = (object) => {
  if ((object.titleinfo.contains(event.target) || object.descriptioninfo.contains(event.target) || object.edit.contains(event.target))
    && isVisible(object.titleinfo) && isVisible(object.descriptioninfo) && isVisible(object.edit)) {
    setTimeout(function(){
      if (object.div.style.display == 'none') {
        object.titleinfo.style.display = 'none';
        object.descriptioninfo.style.display = 'none';
        object.edit.style.display = 'none';
        object.div.style.display = 'block';
      }
    }, 200);
  }
  else if ((!object.div.contains(event.target) || (object.submitbutton == event.target) || (object.button == event.target)) && (isVisible(object.title) && isVisible(object.description))) {
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
