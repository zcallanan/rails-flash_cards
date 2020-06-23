import { Controller } from "stimulus"
import { csrfToken } from "@rails/ujs";
import { fetchWithToken } from '../utils/fetch_with_token.js';

export default class extends Controller {
  static targets = [ "owner", "contact", "label", "read", "update" ]

  membership(event){
    event.preventDefault();
    const submitButton = event.target
    const userLabel = this.labelTarget;
    const ownerRow = this.ownerTarget;
    const emailContact = this.contactTarget;
    const readAccess = this.readTarget;
    const updateAccess = this.updateTarget;
    const url = `http://localhost:3000/api/v1/user_groups/${submitButton.dataset.id}/memberships`;
    let readChecked;
    let updateChecked;

    // simple_form visible input value is always 1, so handle it
    (readAccess.checked == true) ? readChecked = 1 : readChecked = 0;
    (updateAccess.checked == true) ? updateChecked = 1 : updateChecked = 0;

    fetchWithToken(url, {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify(
        {
          membership: {
              user_label: userLabel.value,
              email_contact: emailContact.value,
              read_access: readChecked,
              update_access: updateChecked
            }
        }
      )
    })
      .then(response => response.json())
      .then((data) => {
        ownerRow.insertAdjacentHTML('afterend', data.partialToAttach);
        submitButton.disabled = false;
        emailContact.value = '';
        userLabel.value = ''
      })
  }
}




