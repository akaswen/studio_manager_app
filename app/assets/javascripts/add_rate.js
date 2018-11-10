//= require student_api.js

const adjustRate = (() => {
  let menu;
  let userId;
  let rateDiv;

  function setRate(rate) {
    studentApi.addStudent(userId, rate);
    menu.remove();
  }

  function changeRateDiv(rate) {
    rateDiv.textContent = `$${rate}/h`;
  }

  function resetValidations(div, error) {
    div.classList.remove('invalid');
    error.textContent = '';
  }

  function validateForm(div, input, error) {
    if(!input.value) {
      resetValidations(div, error);
      error.textContent = "Please enter a value";
      div.classList.add('invalid');
      return false;
    } else if(input.value.match(/\D/)) {
      resetValidations(div, error);
      error.textContent = "Please only enter a whole number";
      return false;
      div.classList.add('invalid');
    } else {
      resetValidations(div, error);
      return true;
    }
  }

  function addForm(rateInput) {
    let textDiv = document.createElement('DIV');

    let dollarSign = document.createElement('SPAN');
    dollarSign.textContent = '$';

    let input = document.createElement('INPUT');

    let perHour = document.createElement('SPAN');
    perHour.textContent = '/h';

    textDiv.appendChild(dollarSign);
    textDiv.appendChild(input);
    textDiv.appendChild(perHour);

    let errorMessage = document.createElement('P');

    let button = document.createElement('BUTTON');
    button.className = 'btn btn-outline-warning';
    button.textContent = 'Set';

    button.addEventListener('click', () => {
      let result = validateForm(textDiv, input, errorMessage);
      if (result) {
        setRate(input.value);
        if (rateDiv) {
          changeRateDiv(input.value);
        }
      }
    });

    input.addEventListener('input', () => {
      validateForm(textDiv, input, errorMessage);
    });

    rateInput.appendChild(textDiv);
    rateInput.appendChild(errorMessage);
    rateInput.appendChild(button);
  }

  function addRateInput() {
    let rateInput = document.createElement('DIV');
    rateInput.classList.add('inner-menu');
    menu.appendChild(rateInput);
    addForm(rateInput);
  }

  function addMenu(id, rate) {
    let body = document.querySelector('body');
    menu = document.createElement('DIV');
    menu.classList.add('faded-out');

    userId = id;
    rateDiv = rate;

    body.appendChild(menu);

    menu.addEventListener('click', e => {
      e.stopPropagation();
    });

    addRateInput();
  }
  return {addMenu};
})();

