const studentApi = (() => {
  function studentFetch(path, id, method, rate) {
    let metaTag = document.querySelector('meta[name="csrf-token"]');
    let token = metaTag.getAttribute('content');
    return fetch(path, {
      method: method, 
      headers: {
        'X-CSRF-TOKEN': token
      },
    });
  }

  function addStudent(id, rate) {
    let path = `/add_student?id=${id}&rate=${rate}`;
    return studentFetch(path, id, 'PATCH', rate);
  }

  function waitListStudent(id) {
    let path = `/wait_list?id=${id}`;
    return studentFetch(path, id, 'PATCH');
  }

  function deactivateStudent(id) {
    let path = `/users/${id}`;
    return studentFetch(path, id, 'DELETE');
  }

  return {addStudent, waitListStudent, deactivateStudent};
})();
