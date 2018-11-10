//= require student_api.js

const adjustRate = (() => {
  let menu;

  function resetValidations(div, error) {
    div.classList.remove('invalid');
    error.textContent = '';
  }

  function validateForm(div, input, error) {
    if(!input.value) {
      resetValidations(div, error);
      error.textContent = "Please enter a value";
      div.classList.add('invalid');
    } else {
      resetValidations(div, error);
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
      validateForm(textDiv, input, errorMessage);
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

  function addMenu() {
    let body = document.querySelector('body');
    menu = document.createElement('DIV');
    menu.classList.add('faded-out');

    body.appendChild(menu);

    menu.addEventListener('click', e => {
      e.stopPropagation();
      if(e.target == menu) {
        menu.remove();
      }
    });

    addRateInput();
  }
  return {addMenu};
})();

const show = (() => {
  function load (showDiv) {
    id = showDiv.getAttribute('data-id');
    showDiv.addEventListener('click', e => {
      switch (e.target.textContent) {
        case "Add to Studio":
          console.log('adding to studio');
          //studentApi.addStudent(id).then(() => { 
            //document.location.href = '/users?student=true';
          //});
          break;
        case "Wait List":
          console.log('wait listing');
          //studentApi.waitListStudent(id).then(() => {
            //document.location.href = '/users?status=Wait+Listed';
          //});
          break;
        case "Adjust":
          console.log('adjusting');
          adjustRate.addMenu();
          break;
      }
    });
  }

  return {load};
})();
