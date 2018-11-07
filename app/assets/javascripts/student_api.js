const studentApi = (() => {
  function fetchPath(path, id) {
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
    fetchPath(path, id);
  }

  function waitListStudent(id) {
    let path = '/wait_list';
    fetchPath(path, id);
  }

  return {addStudent, waitListStudent};
})();
