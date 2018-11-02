function parentNode(input) {
  let parent = input.parentNode;
  parent.classList.remove('invalid');
  parent.classList.remove('valid');
  return parent;
}

function checkPasswordConfirmation(input) {
  if (input.id === 'user_password_confirmation') {
    let password = document.getElementById('user_password');
    if (input.value !== password.value) {
      input.setCustomValidity("This must be the same as your password");
    } else {
      input.setCustomValidity("");
    }
  }
}

function addError(input) {
  checkPasswordConfirmation(input);
  if (!input.checkValidity()) {
    let parent = parentNode(input);
    parent.classList.add('invalid');
    let error = parent.lastElementChild;
    if (input.validity.patternMismatch) {
      switch(input.id) {
        case "user_addresses_attributes_0_zip_code":
          error.textContent = 'Please enter 5 digit number';
          break;
        case "user_phone_numbers_attributes_0_number":
          error.textContent = 'Please enter a 10 digit phone number';
          break;
        case "user_password":
          if (!input.value.match(/\d/)) {
            error.textContent = 'Please include at least 1 number';
          } else {
            error.textContent = 'Please include at least 1 capital';
          }
          break;
      }
    } else {
      error.textContent = input.validationMessage;
    }
  }
}

function addValid(input) {
  checkPasswordConfirmation(input);
  if(input.checkValidity()) {
    let parent = parentNode(input);
    parent.classList.add('valid');
    let message = parent.lastElementChild;
    message.textContent = '\u2713';
  }
}

document.addEventListener('turbolinks:load', () => {
  let inputs = document.querySelectorAll('#create_new_user input');
  let form = document.getElementById('create_new_user');
  if (inputs.length > 0) {
    [...inputs].forEach(input => {
      input.addEventListener('focusout', e => {
        addError(e.target);
      });

      input.addEventListener('input', e => {
        addValid(e.target);
      });
    });

    form.addEventListener('submit', e => {
      if (!e.target.checkValidity()) {
        e.preventDefault();
        [...inputs].forEach(input => addError(input));
      }
    });
  }
});
