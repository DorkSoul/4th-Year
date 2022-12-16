## Explain using code examples what is meant by props and state in React JS?
props and state are both plain JavaScript objects.
Prop is the data passed into a React component. They work like HTML attributes or JS function arguments.
whereas state is managed within the component.
Props are a type of pure functionsso you can't change a component modifying its own props.
You can, however, modify the state of a component.

code from https://lucybain.com/blog/2016/react-state-vs-pros/
```
function Welcome(props) {
  return <h1>Hello {props.name}</h1>;
}
```
in this example "name" in props.name is the property that has a value passed into it

Like props, state holds information about the component. However, the kind of information and how it is handled is different.

```
class Button extends React.Component {
  constructor() {
    super();
    this.state = {
      count: 0,
    };
  }

  updateCount() {
    this.setState((prevState, props) => {
      return { count: prevState.count + 1 }
    });
  }

  render() {
    return (<button
              onClick={() => this.updateCount()}
            >
              Clicked {this.state.count} times
            </button>);
  }
}
```
above is code for a button that keeps track of how many times you’ve clicked it
the constructor shows a state. the count:0 will be changings as it runs which is the state changing but the actual prob is still the same one

## In functional programming, what does the term functor mean? Can you give an example in JavaScript?
refrenced https://medium.com/javascript-scene/functors-categories-61e031bac53f
A functor data type is something you can map over.
It’s a container which has an interface which can be used to apply a function to the values inside it.
Functor types are usually a .map() method that maps from inputs to outputs while preserving thier type.
A functor supplies a box with zero or more things inside, and a mapping interface.
An example of this is an array.
```
const f = [1, 2, 3];
f.map(double); // [2, 4, 6]
```

## We have looked at three kinds of asynchronous programming mechanisms, namely callbacks, promises and streams. Mention one advantage and one disadvantage of each type.
|           | Advantage                                                                                                                                                                                                                                     | Disadvantage                                                                                                                                                                                                                                                                                   |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Callbacks | Callbacks are a simple and straightforward way to handle async operations in JavaScript. They are easy to understand and implement, even for developers with little experience with async programming                                         | Callbacks can lead to "callback hell," where code becomes difficult to read and maintain due to the nested nature of callbacks. This can be especially problematic when dealing with multiple async operations that need to be sequenced or parallelized                                       |
| Promises  | Promises provide a cleaner and more readable syntax for handling async operations, compared to callbacks. They allow you to chain async operations together in a more readable and maintainable way, using .then() and .catch() methods.      | Promises can be somewhat more difficult to understand and work with, especially for developers who are new to async programming. It can take some time to get used to the Promise syntax and understand how to chain async operations together using .then() and .catch().                     |
| Streams   | Streams allow you to process data incrementally, rather than having to load the entire dataset into memory at once. This can be useful when working with large datasets, or when the data is coming from a source that is slow or unreliable. | Streams can be more complex to work with than other async programming techniques, such as callbacks or promises. They involve a different programming paradigm, and require a deeper understanding of how to read and write data from streams, handle errors, and manipulate the flow of data. |

## With the aid of a diagram and example code, describe the Cascading Style Sheets (CSS) Box Model and show how it can be used to space DOM elements
some refrences to https://developer.mozilla.org/en-US/docs/Web/CSS/content
The CSS Box Model is a way of representing the layout of HTML elements on a webpage. It consists of several different components:

Content: This is the element's actual content, such as text or an image. It is the blue area in the diagram.

Padding: This is the space between the content and the border. It is transparent and is used to create space around the content.

Border: This is a line around the padding and content. It can be styled using various CSS properties, such as color, width, and style (e.g. solid, dotted, etc.).

Margin: This is the space outside of the border. It is also transparent and is used to create space between elements.

Here is a diagram illustrating the CSS Box Model:

![CSS Box Model](https://github.com/DorkSoul/4th-Year/blob/main/Rich%20Web/Lab4/lecture-review/CSS-Box-Model.JPG)

To use the CSS Box Model, you can set values for the different components using CSS properties. For example, you can use the padding property to set the padding for an element, and the margin property to set the margin for an element.

Here is an example of how you can use the CSS Box Model to space DOM elements:

```
/* Set the padding for the element to 20 pixels */
.my-element {
  padding: 20px;
}

/* Set the margin for the element to 40 pixels */
.my-element {
  margin: 40px;
}

/* Set the border for the element to a solid line with a width of 1 pixel and a color of red */
.my-element {
  border: 1px solid red;
}
```
You can also set different values for the top, right, bottom, and left sides of the element using the padding-top, padding-right, padding-bottom, padding-left, margin-top, margin-right, margin-bottom, and margin-left properties.
```
/* Set the padding for the top and bottom sides of the element to 20 pixels, and the padding for the left and right sides to 10 pixels */
.my-element {
  padding-top: 20px;
  padding-bottom: 20px;
  padding-left: 10px;
  padding-right: 10px;
}

/* Set the margin for the top and bottom sides of the element to 40 pixels, and the margin for the left and right sides to 20 pixels */
.my-element {
  margin-top: 40px;
  margin-bottom: 40px;
  margin-left: 20px;
  margin-right: 20px;
}
```


## Detail how the browser loads and bootstraps a rich web application from an initial URL
When a user enters a URL into their web browser or clicks on a link to a web page, the browser sends a request to the web server associated with the URL. The web server responds by sending back the HTML document for the web page.

The HTML document contains the content of the web page, as well as instructions for the browser on how to render that content and interact with the user. This includes information about any stylesheets, scripts, and other resources that the browser needs to download and use to render the page correctly.

When the browser receives the HTML document, it starts to parse and render the content of the page. As it encounters links to other resources (such as stylesheets and scripts), it sends additional requests to the server to retrieve these resources.

Once all of the resources have been downloaded and the page has been fully rendered, the browser has "bootstrapped" the web application. At this point, the web application is fully loaded and the user can interact with it.

There are many factors that can affect the performance and loading time of a web application, including the size and complexity of the HTML document and the resources it references, the speed of the network connection, and the performance of the web server and the browser itself.
