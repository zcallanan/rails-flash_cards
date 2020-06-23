// swap visibility of strings & forms
const toggleFormInline = (event, object) => {
  if (object.form.style.display == 'none') {
      object.title.style.display = 'none';
      object.description.style.display = 'none';
      object.edit.style.display = 'none';
      object.form.style.display = 'block';
  } else if (object.form.style.display == 'block') {
    object.form.style.display = 'none';
    object.description.style.display = 'block';
    object.title.style.display = 'block';
    object.edit.style.display = 'block';
  }
};

export { toggleFormInline }
