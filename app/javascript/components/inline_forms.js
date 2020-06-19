const ToggleFormInline = (string, form) => {
  if (window.getComputedStyle(string).getPropertyValue('display') == 'block') {
      string.style.display = 'none';
      form.style.display = 'block';
    }
};

const DeckTitleFormInline = () => {
  const deckTitle = document.getElementById('deck-title')
  const deckTitleForm = document.getElementById('deck-title-form')
  deckTitle.addEventListener('click', () => ToggleFormInline(deckTitle, deckTitleForm))
};

const DeckDescriptionFormInline = () => {
  const deckDescription = document.getElementById('deck-description')
  const deckDescriptionForm = document.getElementById('deck-description-form')
  deckDescription.addEventListener('click', () => ToggleFormInline(deckDescription, deckDescriptionForm))
};

export { DeckTitleFormInline, DeckDescriptionFormInline, ToggleFormInline}
