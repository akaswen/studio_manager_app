//= require student_api.js

const show = (() => {
  function load (showDiv) {
    id = showDiv.getAttribute('data-id');
    showDiv.addEventListener('click', e => {
      if (e.target.textContent == "Add to Studio") {
        studentApi.addStudent(id).then(() => { 
          document.location.href = '/users?student=true';
        });
      } else if (e.target.textContent == "Wait List") {
        studentApi.waitListStudent(id).then(() => {
          document.location.href = '/users?status=Wait+Listed';
        });
      }
    });
  }

  return {load};
})();
