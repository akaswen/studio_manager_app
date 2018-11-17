//= require student_api
//= require add_rate
//= require lesson_api

const studentListAdjuster = (() => {
  let studentListItems;
  let lessonListItems;

  function removeElement(element) {
    element.remove();
    let studentIndex = studentListItems.indexOf(element);
    if (lessonListItems) {
      let lessonIndex = lessonListItems.indexOf(element);
      let lessonNumber = document.getElementById('lesson_count');
      if (lessonIndex >= 0) {
        lessonListItems.splice(lessonIndex, 1);
        lessonNumber.textContent =  `(${lessonListItems.length})`;
      }
    }
    if (studentIndex >= 0) {
      studentListItems.splice(studentIndex, 1);
      let studentNumber = document.getElementById('student_count');
      studentNumber.textContent = `(${studentListItems.length})`;
    }

  }

  function adjust(e) {
    let id = e.currentTarget.id;
    let decision = e.target.getAttribute('data-decision');
    let lessonOccurence = e.target.getAttribute('data-occurence');
    if (decision === 'add') {
      removeElement(e.currentTarget);
      adjustRate.addMenu(id);
    } else if (decision === 'wait-list') {
      console.log('wait listing');
      removeElement(e.currentTarget);
      studentApi.waitListStudent(id);
    } else if (decision === 'deactivate') {
      removeElement(e.currentTarget);
      studentApi.deactivateStudent(id);
    } else if (decision === 'confirm') {
      removeElement(e.currentTarget);
      lessonApi.confirmLesson(id, lessonOccurence);
    } else if (decision === 'delete') {
      removeElement(e.currentTarget);
      lessonApi.deleteLesson(id, lessonOccurence)
    }
  }

  function enableAdjusting(studentNodes, lessonNodes) {
    studentListItems = [...studentNodes];
    [...studentListItems].forEach(item => {
      item.addEventListener('click', adjust);
    });
    if (lessonNodes) {
      lessonListItems = [...lessonNodes];
      [...lessonListItems].forEach(item => {
      item.addEventListener('click', adjust);
    });

    }
  }

  return {enableAdjusting};
})();
