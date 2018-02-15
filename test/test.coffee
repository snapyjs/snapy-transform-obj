{test, Promise} = require "snapy"


test (snap) =>
  # state contains value2
  snap obj: "value", transform: (val) => val+2

test (snap) =>
  # state contains value3
  snap obj: "value", transform: (val) => Promise.resolve(val+3)

test (snap) =>
  # state contains json
  snap obj: '{"some":"json","and":"more"}', transform: JSON.parse, filter: "some"

test (snap) =>
  # state contains 1,2
  snap obj: [1,2], transform: "toString"

test (snap) =>
  # state contains 2
  snap obj: [1,2], transform: "length"

test (snap) =>
  # state contains 2
  snap obj: {arr: [1,2]}, transform: arr: "length"

test (snap) =>
  # state contains 2, 3 and array
  snap 
    obj: 
      len: [1,2]
      strlen: [1,2]
      json: '{"arr":[1,2]}'
    transform: 
      len: "length"
      strlen: ["toString","length"]
      json: [JSON.parse, "arr", "toString"]
