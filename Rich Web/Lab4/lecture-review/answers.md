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