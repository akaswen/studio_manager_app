//= require student_list_adjuster

const teacherSidebar = (() => {

  function load (studentToggle) {
    let studentNodes = document.querySelectorAll('#new_students li');
    studentToggle.addEventListener('click', toggleArrow)
    studentListAdjuster.enableAdjusting(studentNodes);
  }

  function toggleArrow() {
    let icon = document.querySelector('#new_student_toggle i');
    icon.classList.toggle('fa-sort-up');
    icon.classList.toggle('fa-sort-down');
  }

  return {load};
})();
