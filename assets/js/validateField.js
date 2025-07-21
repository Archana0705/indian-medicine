function validateField({ selector, pattern, errorMessage, isRequired = true }) {
  const input = $(selector);
  const value = input.val().trim();
  let isValid = true;

  input.closest('.t-Form-inputContainer').find('.field-error').remove();

  if (isRequired && !value) {
    input.closest('.t-Form-inputContainer')
      .append(`<span class="field-error" style="color:red;">This field is required</span>`);
    return false; 
  }

  if (value && pattern && !pattern.test(value)) {
    input.closest('.t-Form-inputContainer')
      .append(`<span class="field-error" style="color:red;">${errorMessage}</span>`);
    isValid = false;
  }

  return isValid;
}

function validateEmptyFields() {
  let allValid = true;

  $('[data-required="true"]').each(function () {
    const $input = $(this);
    const value = $input.val()?.trim();

    // Remove old error
    $input.closest('.t-Form-inputContainer').find('.field-error').remove();

    if (!value) {
      $input.closest('.t-Form-inputContainer')
        .append(`<span class="field-error" style="color:red;">This field is required</span>`);
      allValid = false;
    }
  });

  return allValid;
}



export { validateField, validateEmptyFields }