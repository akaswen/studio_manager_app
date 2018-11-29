//= require student_list_adjuster

const teacherSidebar = (() => {

  function load (sidebar) {
    let toggleButtons = document.querySelectorAll('button[data-toggle="collapse"]')
    let students = document.querySelectorAll('#new_students li');

    toggleButtons.forEach(button => {
      button.addEventListener('click', toggleArrow)
    });
    studentListAdjuster.enableAdjusting(students);
  }

  function toggleArrow(e) {
    let icon = e.currentTarget.firstElementChild.lastElementChild;
    icon.classList.toggle('fa-sort-up');
    icon.classList.toggle('fa-sort-down');
  }

  return {load};
})();
