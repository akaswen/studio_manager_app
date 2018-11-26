//= require lesson_api

const lessonShow = (() => {

  function updateLesson(e) {
    let action = e.target.getAttribute('data-action');
    if (action === "confirm") {
      let id = e.target.getAttribute('data-id');
      let occurence = e.target.getAttribute('data-occurence');
      lessonApi.confirmLesson(id, occurence).then(() => {
        window.location.reload();
      });
    }
  }

  function load(showDiv) {
    showDiv.addEventListener('click', updateLesson);
  }

  return {load};
})();
