//= require my_fetch

const studentApi = (() => {
  function addStudent(id, rate) {
    let path = `/add_student?id=${id}&rate=${rate}`;
    return myFetch(path, 'PATCH');
  }

  function waitListStudent(id) {
    let path = `/wait_list?id=${id}`;
    return myFetch(path, 'PATCH');
  }

  function deactivateStudent(id) {
    let path = `/users/${id}`;
    return myFetch(path, 'DELETE');
  }

  return {addStudent, waitListStudent, deactivateStudent};
})();
