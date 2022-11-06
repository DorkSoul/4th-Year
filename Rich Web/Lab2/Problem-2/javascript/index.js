

fetch('https://jsonplaceholder.typicode.com/posts')
.then((response) => response.json())
.then((data) => data.filter(name => name.title.split(' ').length > 5))
.then((data) => console.log(data));
	
	
function freqMap(string) {  
	var words =string.replace(/[.]/g, '').split(/\s/);
	var map = {};
	words.forEach(function(word) {
		if (!map[word]) {
			map[word] = 0;
		}
		map[word] +=1;
	});
	return map;
}
	  
fetch('http://jsonplaceholder.typicode.com/posts?')
.then(response => response.json())
.then(result => result.forEach(json => console.log(freqMap(json.body))));