async function  adduser() {
	let userData = [],
	repoData = [],
	userinput = document.getElementById("username").value;
	document.getElementById("grid-container-right").innerHTML="";
	

	userData = await fetch(('https://api.github.com/users/' + userinput))
	.then((response) => response.json());

	console.log(userData);

	userData.avatar_url != null ? document.getElementById("user-picture").src = userData.avatar_url : 
	document.getElementById("name").src = 'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png';

	userData.name != null ? document.getElementById("name").innerHTML = 'name: ' + userData.name : 
	document.getElementById("name").innerHTML = 'No name on account';

	userData.login != null ? document.getElementById("user-login").innerHTML = 'username: ' + userData.login : 
	document.getElementById("user-login").innerHTML = 'no username on account';

	userData.email != null ? document.getElementById("email").innerHTML = 'email: ' + userData.email : 
	document.getElementById("email").innerHTML = 'no email on account';

	userData.location != null ? document.getElementById("location").innerHTML = 'location: ' + userData.location : 
	document.getElementById("location").innerHTML = 'no location on account';

	userData.public_repos != null ? document.getElementById("number-of-gits").innerHTML = 'public repos: ' + userData.public_repos : 
	document.getElementById("number-of-gits").innerHTML = 'no public repos on account';

	repoData = await fetch(('https://api.github.com/users/' + userinput + '/repos'))
	.then((response) => response.json());

	console.log(repoData);

	for (var key in repoData) {
		if (repoData.hasOwnProperty(key)) {

			repoData[key].name != null ? repoName = 'repo name: ' + repoData[key].name : repoName = 'no repo name'
			repoData[key].description != null ? repoDesc = 'repo description: ' + repoData[key].description : repoDesc = 'no repo description'

			document.getElementById("grid-container-right").insertAdjacentHTML("beforeend", 
			('<div class="grid-item-repos">' + repoName + '<br>' + repoDesc + '</div>'));

			
		}
	}
}	