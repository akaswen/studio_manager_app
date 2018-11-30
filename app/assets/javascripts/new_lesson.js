//= require my_fetch
//= require my_alert


const newLesson = (() => {
  let lessons;
  let path = `/users.json?student=true`;
  let studentsDiv = document.createElement('SPAN');
  studentsDiv.className = 'student-select';
  
  
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

  function submitForm(time, day, location, length, occurence, studentId) {
    let loading = myAlert.loadingMenu();
    let path = `/lessons?time=${day + ' ' + time}&length=${length}&location=${location}&occurence=${occurence}&id=${studentId}`;
    myFetch(path, 'POST').then(response => {
      if (response.ok) {
        window.location.reload(true)
      } else {
        loading.remove();
        myAlert.message('This time is not available for weekly lessons as it is occupied in a future week.');
      }
    });
  }

  function addForm(button) {
    let innerMenu = myAlert.newMenu();
    let submitButton = innerMenu.lastElementChild;
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

    submitButton.addEventListener('click', e => {
      let location = selectLocation.lastElementChild.value;
      let length = selectLength.lastElementChild.value;
      let radios = document.querySelectorAll('input');
      let occurenceNode = ([...radioOccuring.children].filter(node => node.checked === true));
      let occurence = occurenceNode[0].value
      let studentId = studentsDiv.lastElementChild ? studentsDiv.lastElementChild.value : null

      submitForm(startTime, weekDay, location, length, occurence, studentId);
    });

    form.appendChild(header);
    form.appendChild(studentsDiv);
    form.appendChild(time);
    form.appendChild(day);
    form.appendChild(selectLocation);
    form.appendChild(selectLength);
    form.appendChild(radioOccuring);
    innerMenu.appendChild(form);
  }

  function enableRequesting(e) {

    if (e.target.nodeName === "BUTTON") {
      if (e.target.className.includes('danger')) {
        myAlert.message('this slot is not available');
      } else if (e.target.nextElementSibling.className.includes('danger')) {
        myAlert.message('must have at least 30 minutes of available time');
      } else if (e.target.className.includes('success')) {
        addForm(e.target);
      }
    }
  }

  function load (lessonRequestDiv) {

    lessons = lessonRequestDiv;
    lessonRequestDiv.addEventListener('click', enableRequesting);

    myFetch(path).then(response => {
      return response.json();
    }).then(response => {
      let header = document.createElement('LABEL');
      header.textContent = "Choose Student";

      let select = document.createElement('SELECT');
      select.id = 'student';
      select.name = 'student';

      response.forEach(student => {
        let option = document.createElement('OPTION');
        option.textContent = `${student.first_name} ${student.last_name}`;
        option.value = student.id;

        select.appendChild(option);
      });
      studentsDiv.appendChild(header);
      studentsDiv.appendChild(select);
    }).catch((err) => {
      console.log(err);
    });
  }

  return {load}
})();
