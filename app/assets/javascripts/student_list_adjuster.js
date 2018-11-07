//= require student_api

const studentListAdjuster = (() => {
  let studentListItems;

  function removeElement(element) {
    element.remove();
    let index = studentListItems.indexOf(element);
    studentListItems.splice(index, 1);
    let number = document.getElementById('student_count');
    number.textContent = `(${studentListItems.length})`;
  }

  function adjust(e) {
    let userId = e.currentTarget.id;
    let decision = e.target.getAttribute('data-decision');
    if (decision === 'add') {
      removeElement(e.currentTarget);
      studentApi.addStudent(userId);
    } else if (decision === 'wait-list') {
      removeElement(e.currentTarget);
      studentApi.waitListStudent(userId);
    } else if (decision === 'deactivate') {
      removeElement(e.currentTarget);
      studentApi.deactivateStudent(userId);
    }
  }

  function enableAdjusting(studentNodes) {
    studentListItems = [...studentNodes]; 
    studentListItems.forEach(studentItem => {
      studentItem.addEventListener('click', adjust);
    });
  }

  return {enableAdjusting};
})();
