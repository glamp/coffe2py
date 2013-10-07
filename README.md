# coffee2py
There are 2 steps:
- run the node server w/ coffeescript
- run you some Python

## Running the server

    $ npm install
    $ coffee c2py.coffee

## Calling the server

    curl -X POST -H "Content-Type: application/json" -d '{"code": "x = range(10)"}' localhost:3000
    curl -X POST -H "Content-Type: application/json" -d '{"code": "x"}' localhost:3000

