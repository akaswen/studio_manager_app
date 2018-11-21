//= require student_api.js
//= require my_alert

const adjustRate = (() => {
  let fadedScreen;
  let userId;
  let rateDiv;
  let forwardPath;

  function setRate(rate) {
    fadedScreen.remove();
    let loading = myAlert.loadingMenu();
    studentApi.addStudent(userId, rate).then(() => {
      if (forwardPath) {
        document.location.href = forwardPath;
      } else {
        loading.remove();
      }
    });
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
      div.classList.add('invalid');
      return false;
    } else {
      resetValidations(div, error);
      return true;
    }
  }

  function addForm(rateInput) {
    let title = document.createElement('h4');
    title.textContent = "Rate Per Hour to Charge";

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

    rateInput.appendChild(title);
    rateInput.appendChild(textDiv);
    rateInput.appendChild(errorMessage);
    rateInput.appendChild(button);
  }

  function addMenu(id, rate, path) {
    let body = document.querySelector('body');
    fadedScreen = myAlert.newMenu(false);
    let innerMenu = fadedScreen.firstElementChild;

    userId = id;
    rateDiv = rate;
    forwardPath = path

    addForm(innerMenu);
  }
  return {addMenu};
})();

