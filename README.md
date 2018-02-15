# snapy-transform-obj

Plugin of [snapy](https://github.com/snapyjs/snapy).

Transform an object before you take a snapshot.

```js
{test} = require("snapy")

test((snap) => {
  // simple
  snap({obj: '{"some":"json","and":"more"}', transform: JSON.parse})

  // complex
  snap({
    obj: 
      prop1: "test"
      prop2: 100
      prop3: '{"arr":[1,2]}'
    transform: 
      prop1: "length"
      prop2: ["toString","length"]
      prop3: [JSON.parse, "arr", "toString"]
  })
})
```

## License
Copyright (c) 2017 Paul Pflugradt
Licensed under the MIT license.
