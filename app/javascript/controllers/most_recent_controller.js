import { Controller } from "stimulus"
import { fetchWithToken } from '../utils/fetch_with_token.js';

export default class extends Controller {
  static targets = [
    'recentOneDiv',
    'recentTwoDiv',
    'recentThreeDiv'
  ]

  connect() {
    const recentOneDiv = this.recentOneDivTarget;
    const recentTwoDiv = this.recentTwoDivTarget;
    const recentThreeDiv = this.recentThreeDivTarget;
    const url = 'http://localhost:3000/api/v1/decks/recent_decks';

    fetchWithToken( url, {
        method: "GET",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      })
        .then(response => response.json())
        .then((data) => {
          recentOneDiv.innerHTML = '';
          recentTwoDiv.innerHTML = '';
          recentThreeDiv.innerHTML = '';
          data.data.partials.forEach((partial, index) => {
            if (index === 0) {
              recentOneDiv.innerHTML = partial;
            } else if (index === 1) {
              recentTwoDiv.innerHTML = partial;
            } else if (index === 2) {
              recentThreeDiv.innerHTML = partial;
            }
          })


        });
  }
}
