// import { csrfToken } from "@rails/ujs";
// import { fetchWithToken } from '../utils/fetch_with_token.js';

// window.addEventListener('DOMContentLoaded', (event) => {
//   const membershipFormBool = !!(document.getElementById('new_membership'));
//   const membershipCreateForm = document.getElementById('new_membership');
//   const submitButton = document.getElementById('membership-submit');
//   const ownerRow = document.getElementById('owner-row');
//   const userLabel = document.getElementById('membership_user_label');
//   const emailContact = document.getElementById('membership_email_contact');
//   const readAccess = document.getElementById('membership_read_access');
//   const updateAccess = document.getElementById('membership_update_access');
//   const url = `http://localhost:3000/api/v1/user_groups/${submitButton.dataset.id}/memberships`;



// const init = (readChecked, updateChecked) => {
//   return {
//   method: "POST",
//   headers: {
//     "Accept": "application/json",
//     "Content-Type": "application/json"
//   },
//   body: JSON.stringify(
//     {
//       membership: {
//         user_label: userLabel.value,
//         email_contact: emailContact.value,
//         read_access: readChecked,
//         update_access: updateChecked
//       }
//     })
//   }
// };

// if (membershipFormBool) {
//   membershipCreateForm.addEventListener("submit", (event) => {
//     let readChecked;
//     let updateChecked;
//     event.preventDefault();

//     // simple_form visible input value is always 1
//     (readAccess.checked == true) ? readChecked = 1 : readChecked = 0;
//     (updateAccess.checked == true) ? updateChecked = 1 : updateChecked = 0;

//     fetchWithToken(url, init(readChecked, updateChecked))
//       .then(response => response.json())
//       .then((data) => {
//         ownerRow.insertAdjacentHTML('afterend', data.partialToAttach)
//         submitButton.disabled = false
//       });
//   })
// }
// });







