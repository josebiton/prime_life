/*var swiper = new Swiper(".bg-slider-thumbs", {
  spaceBetween: 0,
  slidesPerView: 0,
});

var swiper2 = new Swiper(".bg-slider", {
  spaceBetween: 0,
  
  thumbs: {
    swiper: swiper,
  },
});*/

window.addEventListener("scroll", function(){
  const header = document.querySelector("header");
  header.classList.toggle("sticky", window.scrollY > 0);
});


//Responsive main menu
const menuBtn = document.querySelector(".nav-menu-btn");
const closeBtn = document.querySelector(".nav-close-btn");
const navigation = document.querySelector(".navigation");

menuBtn.addEventListener("click", () => {
  navigation.classList.add("active");
});

closeBtn.addEventListener("click", () => {
  navigation.classList.remove("active");
});

/*let searchForm = document.querySelector(".search-form");

document.querySelector("#search-btn".onclick = () => {
  searchForm.classList.add(active);
});

document.querySelector("#close-search".onclick = () => {
  searchForm.classList.remove(active);
});*/


function openCity(cityName) {
  var i;
  var x = document.getElementsByClassName("tabcontent");
  for (i = 0; i < x.length; i++) {
    x[i].style.display = "none";
  }
  document.getElementById(cityName).style.display = "block";
}




let listElements = document.querySelectorAll('.list__button--click');

listElements.forEach(listElement => {
    listElement.addEventListener('click', ()=>{
        
        listElement.classList.toggle('arrow');

        let height = 0;
        let menu = listElement.nextElementSibling;
        if(menu.clientHeight == "0"){
            height=menu.scrollHeight;
        }

        menu.style.height = `${height}px`;

    })
});

/*function openCity(evt, cityName) {
  // Declare all variables
  var i, content, tab_btn;

  // Get all elements with class="tabcontent" and hide them
  content = document.getElementsByClassName("content");
  for (i = 0; i < content.length; i++) {
    content[i].style.display = "none";
  }

  // Get all elements with class="tablinks" and remove the class "active"
  tab_btn = document.getElementsByClassName("tab_btn");
  for (i = 0; i < tab_btn.length; i++) {
    tab_btn[i].className = tab_btn[i].className.replace(" active", "");
  }

  // Show the current tab, and add an "active" class to the button that opened the tab
  document.getElementById(cityName).style.display = "block";
  evt.currentTarget.className += " active";

  
}*/

