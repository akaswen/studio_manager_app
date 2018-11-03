function toggleArrow() {
  let icon = document.querySelector('#new_student_toggle i');
  icon.classList.toggle('fa-sort-up');
  icon.classList.toggle('fa-sort-down');
}

const newStudents = (() => {
  let students;

  function sort(e) {
    console.log(e.target);
    console.log(e.currentTarget);
  }

  function enableSorting() {
    studentListItems = querySelectorAll('#new_students li'); 
    [...studentListItems].forEach(studentItem => {
      studentItem.addEventListener('click', sort);
    });
  }

  return {enableSorting};
})();

window.addEventListener('turbolinks:load', () => {
  let studentToggle = document.querySelector('#new_student_toggle');
  if (studentToggle) {
    studentToggle.addEventListener('click', toggleArrow)
    newStudents.enableSorting();
  }
});
