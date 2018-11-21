const myAlert = (() => {
  function loadingMenu() {
    let menu = newMenu(false);
    let innerMenu = menu.firstElementChild;
    let loadingDiv = document.createElement('DIV');
    let loadingTitle = document.createElement('H4');
    let loader = document.createElement('SPAN');

    loadingTitle.textContent = "loading";
    loader.className = 'loader';

    loadingDiv.appendChild(loadingTitle);
    loadingDiv.appendChild(loader);
    innerMenu.appendChild(loadingDiv);
    return menu;
  }

  function newMenu(button=true) {
    let body = document.querySelector('body');
    let fadedScreen = document.createElement('DIV');
    let innerMenu = document.createElement('DIV');

    fadedScreen.className = 'faded-out';
    innerMenu.className = 'inner-menu';

    fadedScreen.appendChild(innerMenu);
    body.appendChild(fadedScreen);

    fadedScreen.addEventListener('click', e => {
      e.stopPropagation();
    });

    if (button) {
      let submit = document.createElement('BUTTON');

      submit.className = 'btn btn-outline-primary';
      submit.textContent = 'Okay';

      innerMenu.appendChild(submit);

      submit.addEventListener('click', () => {
        fadedScreen.remove();
      });

      return innerMenu;
    } else {
      return fadedScreen;
    }
  }

  function message(message) {
    let innerMenu = newMenu();

    let contentDiv = document.createElement('DIV');
    let header = document.createElement('H4');
    header.textContent = message;
    
    contentDiv.appendChild(header)
    innerMenu.appendChild(contentDiv);
  }

  return {message, newMenu, loadingMenu};
})();

