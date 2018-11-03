function toggleArrow() {
  let icon = document.querySelector('#new_student_toggle i');
  icon.classList.toggle('fa-sort-up');
  icon.classList.toggle('fa-sort-down');
}

const newStudents = (() => {
  let studentListItems;

  function removeElement(element) {
    element.parentNode.removeChild(element);
    studentListItems = document.querySelectorAll('#new_students li');
    let number = document.querySelector('#new_student_toggle em');
    number.textContent = `(${studentListItems.length})`;
  }

  function patchFetch(path, id) {
    let metaTag = document.querySelector('meta[name="csrf-token"]');
    let token = metaTag.getAttribute('content');
    fetch(path, {
      method: 'PATCH', 
      headers: {
        'X-CSRF-TOKEN': token
      },
      body: JSON.stringify({
        id: id
      })
    });
  }

  function addStudent(id) {
    let path = '/add_student';
    patchFetch(path, id);
  }

  function waitListStudent(id) {
    let path = '/wait_list';
    patchFetch(path, id);
  }

  function sort(e) {
    let userId = e.currentTarget.id;
    let decision = e.target.getAttribute('data-decision');
    if (decision === 'add') {
      removeElement(e.currentTarget);
      addStudent(userId);
    } else if (decision === 'wait-list') {
      removeElement(e.currentTarget);
      waitListStudent(userId);
    }
  }

  function enableSorting() {
    studentListItems = document.querySelectorAll('#new_students li'); 
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
