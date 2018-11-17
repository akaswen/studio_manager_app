const lessonApi = (() => {
  let metaTag = document.querySelector('meta[name="csrf-token"]');
  let token = metaTag.getAttribute('content');

  function confirmLesson(id, occurence) {
    fetch(`/lessons/${id}?occurence=${occurence}`, 
      {
        method: 'PATCH',
        headers: {
          'X-CSRF-TOKEN': token
        }
      }
    )
  }

  function deleteLesson(id, occurence) {
  }

  return {confirmLesson, deleteLesson};
})();
