//= require student_list_adjuster

const index = (() => {
  function load () {
    let studentNodes = document.querySelectorAll('.student_list li');
    studentListAdjuster.enableAdjusting(studentNodes);
  }

  return {load};
})();
