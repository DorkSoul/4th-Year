//fuction to add user data to screen
async function  adduser() {
	//variables
	let userData = [],
	repoData = [],
	userinput = document.getElementById("username").value;
	//ensure right hand repos are deleted from last search
	document.getElementById("grid-container-right").innerHTML="";
	
	//fetch to get user data and turn to json
	userData = await fetch(('https://api.github.com/users/' + userinput))
	.then((response) => response.json());

	console.log(userData);

	//if statments for each text field to see if there is data and to display it or a default message if needed
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

	//fetch repos of searched user and turn into json
	repoData = await fetch(('https://api.github.com/users/' + userinput + '/repos'))
	.then((response) => response.json());

	console.log(repoData);

	//step into each item in the json and take out each name and description
	for (var key in repoData) {
		if (repoData.hasOwnProperty(key)) {
			
			//check if there are values to display or to use default message and store in variable
			repoData[key].name != null ? repoName = 'repo name: ' + repoData[key].name : repoName = 'no repo name'
			repoData[key].description != null ? repoDesc = 'repo description: ' + repoData[key].description : repoDesc = 'no repo description'

			//insert data into a new div
			document.getElementById("grid-container-right").insertAdjacentHTML("beforeend", 
			('<div class="grid-item-repos">' + repoName + '<br><br>' + repoDesc + '</div>'));
		}
	}
	//ensure username field from last search is empty
	document.getElementById("username").value = "";
}	