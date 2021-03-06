//= require add_rate

const userShow = (() => {
  function load (showDiv) {
    let rateDiv = document.getElementById('rate');
    id = showDiv.getAttribute('data-id');
    showDiv.addEventListener('click', e => {
      switch (e.target.textContent) {
        case "Add to Studio":
          adjustRate.addMenu(id, rateDiv, '/users?student=true');
          break;
        case "Wait List":
          studentApi.waitListStudent(id).then(() => {
            document.location.href = '/users?status=Wait+Listed';
          });
          break;
        case "Adjust":
          adjustRate.addMenu(id, rateDiv);
          break;
      }
    });
  }

  return {load};
})();
