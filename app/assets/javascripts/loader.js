//= require dropdown_maker
//= require devise_forms
//= require teacher_sidebar
//= require index

window.addEventListener('turbolinks:load', () => {
  // load dropdown menu
  let icon = document.getElementById('icon');
  let menu = document.getElementById('menu');
  let container = document.querySelector('.container-fluid');
  dropDownMaker.addDropDown(icon, menu, container);


  let studentToggle = document.getElementById('new_student_toggle'); //for teacher sidebar

  let indexDiv = document.getElementById('student_index'); //for index

  let inputs = document.querySelectorAll('#user_form input'); //for devise forms

  if (inputs.length > 0) {
    deviseForms.load(inputs);
  } else if (studentToggle) {
    teacherSidebar.load(studentToggle);
  } else if (indexDiv) {
    index.load(indexDiv);
  }

});

