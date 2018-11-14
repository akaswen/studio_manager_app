//= require dropdown_maker
//= require devise_forms
//= require teacher_sidebar
//= require index
//= require show
//= require edit_schedule
//= require new_lesson

window.addEventListener('turbolinks:load', () => {
  // load dropdown menu
  let icon = document.getElementById('icon');
  let menu = document.getElementById('menu');
  let container = document.querySelector('.container-fluid');
  dropDownMaker.addDropDown(icon, menu, container);


  let studentToggle = document.getElementById('new_student_toggle'); //for teacher sidebar
  let indexDiv = document.getElementById('student_index'); //for index
  let inputs = document.querySelectorAll('#user_form input'); //for devise forms
  let showDiv = document.getElementById('user-show'); //for show page
  let calendar = document.getElementById('schedule-calendar'); //for edit schedule page
  let lessonRequestDiv = document.getElementById('new-lesson'); // for new lesson page

  if (inputs.length > 0) {
    deviseForms.load(inputs);
  } else if (studentToggle) {
    teacherSidebar.load(studentToggle);
  } else if (indexDiv) {
    index.load(indexDiv);
  } else if (showDiv) {
    show.load(showDiv);
  } else if (calendar) {
    schedule.load(calendar);
  } else if (lessonRequestDiv) {
    newLesson.load(lessonRequestDiv);
  }

});

