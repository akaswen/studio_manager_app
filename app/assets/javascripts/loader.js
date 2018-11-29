//= require dropdown_maker
//= require devise_forms
//= require teacher_sidebar
//= require index
//= require user_show
//= require edit_schedule
//= require new_lesson

window.addEventListener('turbolinks:load', () => {
  // load dropdown menu
  let icon = document.getElementById('icon');
  let menu = document.getElementById('menu');
  let container = document.querySelector('.container-fluid');
  dropDownMaker.addDropDown(icon, menu, container);


  let sidebar = document.getElementById('teacher-sidebar'); //for teacher sidebar
  let indexDiv = document.getElementById('student_index'); //for index
  let inputs = document.querySelectorAll('#user_form input'); //for devise forms
  let userShowDiv = document.getElementById('user-show'); //for user show page
  let calendar = document.getElementById('schedule-calendar'); //for edit schedule page
  let lessonRequestDiv = document.getElementById('new-lesson'); // for new lesson page

  if (inputs.length > 0) {
    deviseForms.load(inputs);
  } else if (sidebar) {
    teacherSidebar.load(sidebar);
  } else if (indexDiv) {
    index.load(indexDiv);
  } else if (userShowDiv) {
    userShow.load(userShowDiv);
  } else if (calendar) {
    schedule.load(calendar);
  } else if (lessonRequestDiv) {
    newLesson.load(lessonRequestDiv);
  }

});

