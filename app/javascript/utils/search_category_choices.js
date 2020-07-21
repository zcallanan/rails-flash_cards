const searchCategoryChoices = (data, selectedArray, categoryChoices) => {
  /* After the user makes a selection in the category select,
  this generates choices. Currently selected choices are disabled. */
  let array = [];
  let n = 1;
  let obj;
  data.forEach(row => {
    row[1].forEach(item => {
      selectedArray.forEach(currentlyDisabled => {

        if (currentlyDisabled.value === item.value) {
          item['disabled'] = true;
        }
      })
    })

    obj = {label: row[0], id: n, disabled: false, choices: row[1]}

    array.push(obj);
    n = n + 1
  })
  categoryChoices.setChoices(array, 'value', 'label', true);
}

export { searchCategoryChoices }

