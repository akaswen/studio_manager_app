//= require my_fetch

const lessonApi = (() => {
  function confirmLesson(id, occurence) {
    let path = `/lessons/${id}?occurence=${occurence}`;
    myFetch(path, 'PATCH');
  }

  function deleteLesson(id, occurence) {
    let path;
    if (occurence === 'weekly') {
      path = `/lessons/${id}?destroy_all=${true}`;
    } else {
      path = `/lessons/${id}`;
    }
    myFetch(path, 'DELETE');
  }

  return {confirmLesson, deleteLesson};
})();
