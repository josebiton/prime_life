

// $(".option").click(function(){
// 	$(".option").removeClass("active");
// 	$(this).addClass("active");	
// });


/* zoom de imagenes de galeria */
var fullImgBox = document.getElementById("fullImgBox");
var fullImg = document.getElementById("fullImg");

function openFullImg(pic) {
	fullImgBox.style.display = "flex";
	fullImg.src = pic;
}

function closeFullImg() {
	fullImgBox.style.display = "none";
}

