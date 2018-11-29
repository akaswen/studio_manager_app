//= require student_api
//= require add_rate
//= require lesson_api

const studentListAdjuster = (() => {
  let studentListItems;

  function removeElement(element) {
    element.remove();
    let studentIndex = studentListItems.indexOf(element);
    if (studentIndex >= 0) {
      studentListItems.splice(studentIndex, 1);
      let studentNumber = document.getElementById('student_count');
      studentNumber.textContent = `(${studentListItems.length})`;
    }
  }

  function adjust(e) {
    let id = e.currentTarget.id;
    let decision = e.target.getAttribute('data-decision');
    if (decision === 'add') {
      removeElement(e.currentTarget);
      adjustRate.addMenu(id);
    } else if (decision === 'wait-list') {
      removeElement(e.currentTarget);
      studentApi.waitListStudent(id);
    } else if (decision === 'deactivate') {
      removeElement(e.currentTarget);
      studentApi.deactivateStudent(id);
    }
  }

  function enableAdjusting(studentNodes) {
    studentListItems = [...studentNodes];
    [...studentListItems].forEach(item => {
      item.addEventListener('click', adjust);
    });
  }

  return {enableAdjusting};
})();
