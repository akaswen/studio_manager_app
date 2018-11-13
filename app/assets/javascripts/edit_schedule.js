const schedule = (() => {
  function toggleButton(button) {
    button.classList.toggle('list-group-item-success');
    button.classList.toggle('list-group-item-danger');
  }

  function load(calendar) {
    calendar.addEventListener('click', e => {
      if (e.target.nodeName === 'BUTTON') {
        toggleButton(e.target);
      } else if (e.target.nodeName === 'SPAN') {
        let dayList = e.target.parentNode.parentNode;
        let timeSlots = [...dayList.childNodes].filter((node) => node.nodeName === 'BUTTON');
        timeSlots.forEach(slot => {
          slot.classList.remove('list-group-item-danger');
          slot.classList.remove('list-group-item-success');

          if (e.target.className.includes('success')) {
            slot.classList.add('list-group-item-success');
          } else {
            slot.classList.add('list-group-item-danger');
          }
        });
      }
    });
  }

  return {load};
})();
