const schedule = (() => {
  let calendar;

  function addLoadingMenu() {
    let body = document.querySelector('body');
    let fadedMenu = document.createElement('DIV');
    fadedMenu.className = 'faded-out';

    fadedMenu.addEventListener('click', e => {
      e.stopPropagation();
    });

    let innerMenu = document.createElement('DIV');
    innerMenu.className = 'inner-menu';

    let loadingDiv = document.createElement('DIV');

    let loadingTitle = document.createElement('H4');
    loadingTitle.textContent = "loading";

    let loader = document.createElement('SPAN');
    loader.className = 'loader';

    loadingDiv.appendChild(loadingTitle);
    loadingDiv.appendChild(loader);
    innerMenu.appendChild(loadingDiv);
    fadedMenu.appendChild(innerMenu);
    body.appendChild(fadedMenu);
  }
  
  function removeLoadingMenu() {
    let fadedMenu = document.querySelector('.faded-out');

    fadedMenu.remove();
  }

  function makeSlotsAvailable(ids) {
    if (ids.length > 0) {
      addLoadingMenu();
      let metaTag = document.querySelector('meta[name="csrf-token"]');
      let token = metaTag.getAttribute('content');
    fetch(`/time_slots?ids=${JSON.stringify(ids)}&available=true`, {
        method: 'PATCH', 
        headers: {
          'X-CSRF-TOKEN': token
        }
      }).then(() => removeLoadingMenu());
    } 
  }

  function makeSlotsUnavailable(ids) {
    if (ids.length > 0) {
      addLoadingMenu();
      let metaTag = document.querySelector('meta[name="csrf-token"]');
      let token = metaTag.getAttribute('content');
    fetch(`/time_slots?ids=${JSON.stringify(ids)}&available=false`, {
        method: 'PATCH', 
        headers: {
          'X-CSRF-TOKEN': token
        },
      }).then(() => removeLoadingMenu());
    } 
  }

  function updateSlotClass(slot, updateButton) {
    slot.classList.remove('list-group-item-danger');
    slot.classList.remove('list-group-item-success');

    if (updateButton.className.includes('success')) {
      slot.classList.add('list-group-item-success');
    } else {
      slot.classList.add('list-group-item-danger');
    }
  }

  function toggleButton(button) {
    if (button.className.includes('success')) {
      makeSlotsUnavailable([button.id]);
    } else {
      makeSlotsAvailable([button.id]);
    }
    button.classList.toggle('list-group-item-success');
    button.classList.toggle('list-group-item-danger');
  }

  function enableChanging(e) {
    if (e.target.nodeName === 'BUTTON') {
      toggleButton(e.target);
    } else if (e.target.nodeName === 'SPAN') {
      let dayList = e.target.parentNode.parentNode;
      let timeSlots = [...dayList.childNodes].filter((node) => node.nodeName === 'BUTTON');
      let slotsToChange = [];
      if (e.target.className.includes('success')) {
        timeSlots.forEach(slot => {
          if (slot.className.match('danger')) slotsToChange.push(slot.id);
        });
        makeSlotsAvailable(slotsToChange);
      } else {
        timeSlots.forEach(slot => {
          if (slot.className.match('success')) slotsToChange.push(slot.id);
        });
        makeSlotsUnavailable(slotsToChange);
      }
      timeSlots.forEach(slot => {
        updateSlotClass(slot, e.target);
      });
    }
  }

  function load(calendarDiv) {
    calendar = calendarDiv;
    calendar.addEventListener('click', enableChanging);
  }

  return {load};
})();
