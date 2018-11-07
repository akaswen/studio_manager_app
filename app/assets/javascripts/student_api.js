const studentApi = (() => {
  function studentFetch(path, id, method) {
    let metaTag = document.querySelector('meta[name="csrf-token"]');
    let token = metaTag.getAttribute('content');
    return fetch(path, {
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
    return studentFetch(path, id, 'PATCH');
  }

  function waitListStudent(id) {
    let path = '/wait_list';
    return studentFetch(path, id, 'PATCH');
  }

  function deactivateStudent(id) {
    let path = `/users/${id}`;
    return studentFetch(path, id, 'DELETE');
  }

  return {addStudent, waitListStudent, deactivateStudent};
})();
