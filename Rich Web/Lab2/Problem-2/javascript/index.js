

//fetch posts, then turn into json, then filter ber white space to break up words and measure the length, then log the data
fetch('https://jsonplaceholder.typicode.com/posts')
.then((response) => response.json())
.then((data) => data.filter(name => name.title.split(' ').length > 5))
.then((data) => console.log(data));

//set empty map variable
let map = {};
//counts words in each item in results
function freqMap(string) {
	//variables splitting the string into words
	let currentItem =string.replace(/[.]/g, '').split(/\s/);
	

	//loop through words
	currentItem.forEach(function(currentWord) {
		//check if it is in the map already and if so increase the count if not set count to 0
		if (!map[currentWord]) {
			map[currentWord] = 0;
		}
		map[currentWord] +=1;
	});
	return map;
}

//fetch posts, then turn into jason, then step through json call the freqmap function adding to the map, then output the map
fetch('http://jsonplaceholder.typicode.com/posts?')
.then(response => response.json())
.then(result => result.forEach(json => freqMap(json.body)))
.then(result => console.log(map));