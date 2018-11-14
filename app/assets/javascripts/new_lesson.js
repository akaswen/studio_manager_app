const newLesson = (() => {
  let lessons;

  function myAlert(message) {
    let body = document.querySelector('body');
    let fadedScreen = document.createElement('DIV');
    fadedScreen.className = 'faded-out';

    let innerMenu = document.createElement('DIV');
    innerMenu.className = 'inner-menu';

    let contentDiv = document.createElement('DIV');

    let header = document.createElement('H4');
    header.textContent = message;

    let button = document.createElement('BUTTON');
    button.className = 'btn btn-outline-primary';
    button.textContent = 'Okay';
    button.addEventListener('click', () => {
      fadedScreen.remove();
    });

    contentDiv.appendChild(header);
    innerMenu.appendChild(contentDiv);
    innerMenu.appendChild(button);
    fadedScreen.appendChild(innerMenu);
    body.appendChild(fadedScreen);
  }

  function enableRequesting(e) {
    if (e.target.className.includes('danger')) {
      myAlert('this slot is not available');
    } else if (e.target.nextElementSibling.className.includes('danger')) {
      myAlert('must have at least 30 minutes of available time');
    }
  }

  function load (lessonRequestDiv) {
    lessons = lessonRequestDiv;
    lessonRequestDiv.addEventListener('click', enableRequesting);
  }

  return {load}
})();
