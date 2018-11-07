const studentApi = (() => {
  function studentFetch(path, id, method) {
    let metaTag = document.querySelector('meta[name="csrf-token"]');
    let token = metaTag.getAttribute('content');
    fetch(path, {
      method: method, 
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
    studentFetch(path, id, 'PATCH');
  }

  function waitListStudent(id) {
    let path = '/wait_list';
    studentFetch(path, id, 'PATCH');
  }

  function deactivateStudent(id) {
    let path = `/users/${id}`;
    studentFetch(path, id, 'DELETE');
  }

  return {addStudent, waitListStudent, deactivateStudent};
})();
