const studentApi = (() => {
  function studentFetch(path, id, method, rate) {
    let metaTag = document.querySelector('meta[name="csrf-token"]');
    let token = metaTag.getAttribute('content');
    return fetch(path, {
      method: method, 
      headers: {
        'X-CSRF-TOKEN': token
      },
      body: JSON.stringify({
        id: id,
        rate: rate
      })
    });
  }

  function addStudent(id, rate) {
    let path = '/add_student';
    return studentFetch(path, id, 'PATCH', rate);
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
