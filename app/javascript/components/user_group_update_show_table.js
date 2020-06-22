import { csrfToken } from "@rails/ujs";

const membershipCreateForm = document.getElementById('new_membership');
const submitButton = document.getElementById('membership-submit');
const ownerRow = document.getElementById('owner-row');

membershipCreateForm.addEventListener("submit", (event) => {
  event.preventDefault();

  const userLabel = document.getElementById('membership_user_label');
  const emailContact = document.getElementById('membership_email_contact');
  const readAccess = document.getElementById('membership_read_access');
  const updateAccess = document.getElementById('membership_update_access');


  const fetchWithToken = (url, options) => {
    options.headers = {
      "X-CSRF-Token": csrfToken(),
      ...options.headers
    };
    options.credentials = "same-origin";

    return fetch(url, options);
  }

  const url = `http://localhost:3000/api/v1/user_groups/${submitButton.dataset.id}/memberships`
  fetchWithToken( url, {
    method: "POST",
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ membership: {
      user_label: userLabel.value,
      email_contact: emailContact.value,
      read_access: readAccess.value,
      update_access: updateAccess.value
    }})
  })
    .then(response => response.json())
    .then((data) => {
      ownerRow.insertAdjacentHTML('afterend', data.partialToAttach)
      submitButton.disabled = false
    });
});
