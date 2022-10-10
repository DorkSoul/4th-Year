
//reverse through array of images
//getting random image from the array we created before (we use math.floor and math.random to grab a random index in the array)
const imgs = document.getElementsByTagName("img");
for(let i = 0; i < imgs.length; i++) {
    imgs[i].src = "https://s.yimg.com/uu/api/res/1.2/sGp_XbjxcOOQfREbUpH9ag--~B/Zmk9ZmlsbDtoPTQyMTt3PTY3NTthcHBpZD15dGFjaHlvbg--/https://s.yimg.com/os/creatr-uploaded-images/2021-02/572c4830-721d-11eb-bb63-96959c3b62f2.cf.webp"
}
//do the same for h1 elements
const headers = document.getElementsByTagName("h1");
for (let i = 0; i < headers.length; i++){
    headers[i].innerText = "YOU HAVE NO POWER HERE";
}
//do the same for p elements
const p = document.getElementsByTagName("p");
for (let i = 0; i < p.length; i++){
    p[i].innerText = "WELCOME TO HELL";
}

let a = document.getElementsByTagName("a");
Array.from(a).forEach((x)=>x.href = "https://www.youtube.com/watch?v=dQw4w9WgXcQ");

//Array.from(document.getElementsByTagName("span")).map(x => x.lastChild);
