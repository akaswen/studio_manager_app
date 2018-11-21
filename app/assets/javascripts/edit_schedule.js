//= require my_fetch
//= require my_alert

const schedule = (() => {
  let calendar;

  function makeSlotsAvailable(ids) {
    if (ids.length > 0) {
      let menu = myAlert.loadingMenu();
      let path = `/time_slots?ids=${JSON.stringify(ids)}&available=true`;
      myFetch(path, 'PATCH').then(() => menu.remove());
    } 
  }

  function makeSlotsUnavailable(ids) {
    if (ids.length > 0) {
      let menu = myAlert.loadingMenu();
      let path = `/time_slots?ids=${JSON.stringify(ids)}&available=false`;
      myFetch(path, 'PATCH').then(response => {
        menu.remove();
        if (!response.ok) {
          ids.forEach(id => {
            let button = document.getElementById(id);
            toggleButton(button);
          });
          myAlert.message("Can't make a time slot unavailable when there are already lessons in it. Please cancel all lessons in time slots and then try again");
        }
      });
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

  function toggleAvailability(button) {
    if (button.className.includes('success')) {
      makeSlotsUnavailable([button.id]);
    } else {
      makeSlotsAvailable([button.id]);
    }
  }

  function toggleButton(button) {
    button.classList.toggle('list-group-item-success');
    button.classList.toggle('list-group-item-danger');
  }

  function enableChanging(e) {
    if (e.target.nodeName === 'BUTTON') {
      toggleAvailability(e.target);
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
