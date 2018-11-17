const newLesson = (() => {
  let lessons;

  function createRadioOccuring() {
    let radioSpan = document.createElement('SPAN');
    let radio1 = document.createElement('INPUT');
    let radio2 =  document.createElement('INPUT');
    let label1 = document.createElement('LABEL');
    let label2 = document.createElement('LABEL');

    radio1.type = 'radio';
    radio2.type = 'radio';
    radio1.value = 'weekly';
    radio2.value = 'single';
    radio1.name = 'occurence';
    radio2.name = 'occurence';
    radio1.checked = true;

    label1.textContent = 'Weekly';
    label2.textContent = 'Single';

    radioSpan.appendChild(label1);
    radioSpan.appendChild(radio1);
    radioSpan.appendChild(label2);
    radioSpan.appendChild(radio2);

    return radioSpan;
  }

  function createSelectLength(button) {
    let selectSpan = document.createElement('SPAN');
    let label = document.createElement('LABEL');
    label.textContent = 'Duration';

    let select = document.createElement('SELECT');
    select.id = 'length';
    select.name = 'duration';
    let option1 = document.createElement('OPTION');
    option1.textContent = '30 minutes';
    option1.value = 30;
    select.appendChild(option1);

    let test45 = button.nextElementSibling.nextElementSibling;
    let test60 = test45.nextElementSibling;

    if (test45.className.includes('success')) {
      let option2 = document.createElement('OPTION');
      option2.textContent = '45 minutes';
      option2.value = 45;
      select.appendChild(option2);
      if (test60.className.includes('success')) {
        let option3 = document.createElement('OPTION');
        option3.textContent = '60 minutes';
        option3.value = 60;
        select.appendChild(option3);
      }
    }
    
    selectSpan.appendChild(label);
    selectSpan.appendChild(select);

    return selectSpan;
  }

  function createSelectLocation() {
    let selectSpan = document.createElement('SPAN');
    let label = document.createElement('LABEL');
    label.textContent = 'Location';

    let select = document.createElement('SELECT');
    select.id = 'location';
    select.name = 'location';
    let option1 = document.createElement('OPTION');
    let option2 = document.createElement('OPTION');
    let option3 = document.createElement('OPTION');
    option1.textContent = "Teacher's studio";
    option1.value = 'teacher';
    option2.textContent = "Student's house";
    option2.value = 'student';

    select.appendChild(option1);
    select.appendChild(option2);

    selectSpan.appendChild(label);
    selectSpan.appendChild(select);

    return selectSpan;
  }

  function submitForm() {
    let time = document.querySelector('form h3').textContent;
    let day = document.querySelector('form h4').textContent;
    let location = document.getElementById('location').value;
    let length = document.getElementById('length').value;
    let radios = document.querySelectorAll('input');
    let occurence = [...radios].filter(radio => radio.checked)[0].value;

    let metaTag = document.querySelector('meta[name="csrf-token"]');
    let token = metaTag.getAttribute('content');
    fetch(`/lessons?time=${day + ' ' + time}&length=${length}&location=${location}&occurence=${occurence}`, {
      method: 'POST',
      headers: {
        'X-CSRF-TOKEN': token
      }
    }).then(() => {
      window.location.reload(true)
    });
  }

  function addForm(button, innerMenu) {
    let startTime = button.getAttribute('data-time');
    let weekDay = button.getAttribute('data-day');

    let form = document.createElement('FORM');
    let header = document.createElement('H5');
    let time = document.createElement('H3');
    let day = document.createElement('H4');
    let selectLocation = createSelectLocation();
    let selectLength = createSelectLength(button);
    let radioOccuring = createRadioOccuring();

    header.textContent = 'Lesson Request';
    time.textContent = `${startTime}`;
    day.textContent = `${weekDay}`;

    form.appendChild(header);
    form.appendChild(time);
    form.appendChild(day);
    form.appendChild(selectLocation);
    form.appendChild(selectLength);
    form.appendChild(radioOccuring);
    innerMenu.appendChild(form);
  }

  function addMessage(message, innerMenu) {
    let contentDiv = document.createElement('DIV');

    let header = document.createElement('H4');
    header.textContent = message;

    contentDiv.appendChild(header);
    innerMenu.appendChild(contentDiv);
  }

  function myAlert(button, message) {
    let body = document.querySelector('body');
    let fadedScreen = document.createElement('DIV');
    fadedScreen.className = 'faded-out';

    let innerMenu = document.createElement('DIV');
    innerMenu.className = 'inner-menu';

    let submit = document.createElement('BUTTON');

    if (message) {
      addMessage(message, innerMenu);
    } else {
      addForm(button, innerMenu);
      submit.addEventListener('click', submitForm);
    }

    submit.className = 'btn btn-outline-primary';
    submit.textContent = 'Okay';
    submit.addEventListener('click', () => {
      fadedScreen.remove();
    });

    innerMenu.appendChild(submit);
    fadedScreen.appendChild(innerMenu);
    body.appendChild(fadedScreen);
  }

  function enableRequesting(e) {
    if (e.target.nodeName === "BUTTON") {
      if (!e.target.className.includes('success')) {
        myAlert(e.target, 'this slot is not available', false);
      } else if (!e.target.nextElementSibling.className.includes('success')) {
        myAlert(e.target, 'must have at least 30 minutes of available time', false);
      } else {
        myAlert(e.target);
      }
    }
  }

  function load (lessonRequestDiv) {
    lessons = lessonRequestDiv;
    lessonRequestDiv.addEventListener('click', enableRequesting);
  }

  return {load}
})();
