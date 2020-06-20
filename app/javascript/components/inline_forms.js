const toggleFormInline = (event, string, form, submit, button) => {
  if (form.style.display == 'none') {
      string.style.display = 'none';
      button.style.display = 'none';
      form.style.display = 'block';
  } else if (form.style.display == 'block') {
    submit.click()
    form.style.display = 'none';
    string.style.display = 'block';
    button.style.display = 'block';
  }
};

const deckFormInline = () => {
  const deckTBool = !!(document.getElementById('deck-title'));
  const deckDesBool = !!(document.getElementById('deck-description'));
  if (deckTBool && deckDesBool) {
    const deckT = document.getElementById('deck-title')
    const deckTEditButton = document.getElementById('deck-edit-button')
    const deckTForm = document.getElementById('deck-title-form')
    const tSubmitButton = document.getElementById('deck-title-submit')
    const deckDes = document.getElementById('deck-description')
    const deckDesEditButton = document.getElementById('deck-des-edit-button')
    const deckDesForm = document.getElementById('deck-description-form')
    const desSubmitButton = document.getElementById('deck-description-submit')
    deckT.addEventListener('click', (e) => toggleFormInline(e, deckT, deckTForm, tSubmitButton, deckTEditButton))
    deckDes.addEventListener('click', (e) => toggleFormInline(e, deckDes, deckDesForm, desSubmitButton, deckDesEditButton))
    document.body.addEventListener('mousedown', (e) => {
      if (!deckTForm.contains(e.target) && !deckDesForm.contains(e.target)) {
        if (deckTForm.style.display == 'block') {
          toggleFormInline(e, deckT, deckTForm, tSubmitButton, deckTEditButton)
        } else if (deckDesForm.style.display == 'block') {
          toggleFormInline(e, deckDes, deckDesForm, desSubmitButton, deckDesEditButton)
        }
      }
    })
  }
};

const collectionFormInline = () => {
  const collTBool = !!(document.getElementById('collection-title'));
  const collDesBool = !!(document.getElementById('collection-description'));
  if (collTBool && collDesBool) {
    const collT = document.getElementById('collection-title')
    const collTEditButton = document.getElementById('collection-edit-button')
    const collTForm = document.getElementById('collection-title-form')
    const collTSubmitButton = document.getElementById('collection-title-submit')
    const collDes = document.getElementById('collection-description')
    const collDesEditButton = document.getElementById('collection-des-edit-button')
    const collDesForm = document.getElementById('collection-description-form')
    const collDesSubmitButton = document.getElementById('collection-description-submit')
    console.log(collTSubmitButton)
    console.log(collDesSubmitButton)
    collT.addEventListener('click', (e) => toggleFormInline(e, collT, collTForm, collTSubmitButton, collTEditButton))
    collDes.addEventListener('click', (e) => toggleFormInline(e, collDes, collDesForm, collDesSubmitButton, collDesEditButton))
    document.body.addEventListener('mousedown', (e) => {
      if (!collTForm.contains(e.target) && !collDesForm.contains(e.target)) {
        if (collTForm.style.display == 'block') {
          toggleFormInline(e, collT, collTForm, collTSubmitButton, collTEditButton)
        } else if (collDesForm.style.display == 'block') {
          toggleFormInline(e, collDes, collDesForm, collDesSubmitButton, collDesEditButton)
        }
      }
    })
  }
};

export { deckFormInline, collectionFormInline, toggleFormInline}
