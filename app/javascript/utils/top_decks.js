import { fetchWithToken } from '../utils/fetch_with_token.js';

const topDecks = (obj) => {
  fetchWithToken( obj.url, {
        method: "GET",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      })
        .then(response => response.json())
        .then((data) => {
          console.log(data);
          obj.topOneDiv.innerHTML = '';
          obj.topTwoDiv.innerHTML = '';
          obj.topThreeDiv.innerHTML = '';
          data.data.partials.forEach((partial, index) => {
            if (index === 0) {
              obj.topOneDiv.innerHTML = partial;
            } else if (index === 1) {
              obj.topTwoDiv.innerHTML = partial;
            } else if (index === 2) {
              obj.topThreeDiv.innerHTML = partial;
            }
          })
        });
}

export { topDecks }
