//= require dropdown_maker

document.addEventListener('turbolinks:load', () => {
  let icon = document.getElementById('icon');
  let menu = document.getElementById('menu');
  let container = document.querySelector('.container-fluid');
  dropDownMaker.addDropDown(icon, menu, container);
});
