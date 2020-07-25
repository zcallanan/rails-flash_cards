import { fetchWithToken } from '../utils/fetch_with_token.js';

const mostRecentDecks = (obj) => {
  fetchWithToken( obj.url, {
        method: "GET",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      })
        .then(response => response.json())
        .then((data) => {
          console.log(data)
          obj.recentOneDiv.innerHTML = '';
          obj.recentTwoDiv.innerHTML = '';
          obj.recentThreeDiv.innerHTML = '';
          data.data.partials.forEach((partial, index) => {
            if (index === 0) {
              obj.recentOneDiv.innerHTML = partial;
            } else if (index === 1) {
              obj.recentTwoDiv.innerHTML = partial;
            } else if (index === 2) {
              obj.recentThreeDiv.innerHTML = partial;
            }
          })
        });
}

export { mostRecentDecks }
