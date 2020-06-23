/*
   If checked, pass collection of values to an update all action
   Update all action iterates through collection, updating all
   Returns JSON list of memberships IDs updated
   Select checkboxes through dataset and updated checked value to true or false
*/

import { fetch_with_token } from '../utils/fetch_with_token.js';

// Select the update all elements.
// const selectAllRead = document.getElementById('read-access-all');
// const selectAllUpdate = document.getElementById('update-access-all');
const updateAllButton = document.getElementById('update-all-permissions');
const updateAllBool = !!(document.getElementById('update-all-permissions'));

const updateAll = () => {
  let readValue;
  let updateValue;
  // On button click, select all checkboxes in two node lists.
  const allReadBoxes = document.querySelectorAll('read-access');
  const allUpdateBoxes = document.querySelectorAll('update-access');

  allReadBoxes.forEach(checkbox => {

  })

  (selectAllRead.checked == true) ? readValue = 1 : readValue = 0;
  (selectAllUpdate.checked == true) ? updateValue = 1 : updateValue = 0;

  fetchWithToken( url, {
    method: "POST",
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ membership: {
      read_access: readValue,
      update_access: updateValue
    }})
  })
    .then(response => response.json())
    .then((data) => {
      ownerRow.insertAdjacentHTML('afterend', data.partialToAttach)
      submitButton.disabled = false
    });
}

if (updateAllBool) {
  updateAllButton.addEventListener('click', updateAll);
}
