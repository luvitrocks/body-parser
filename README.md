# body-parser

> Body parsing middleware for [Utopia](https://github.com/luvitrocks/utopia) and [Luvit.io](https://luvit.io). 

Parse incoming request bodies in a middleware before your handlers, available under the `req.body` property.

_This does not handle multipart bodies_, due to their complex and typically large nature.

This module provides the following parsers:

- [JSON body parser](https://github.com/luvitrocks/body-parser#bodyparserjsonoptions)
- [URL-encoded form body parser](https://github.com/luvitrocks/body-parser#bodyparserurlencodedoptions)
- [Text body parser](https://github.com/luvitrocks/body-parser#bodyparsertextoptions)

## Install

```bash
lit install voronianski/body-parser
```

## API

```lua
local bodyParser = require('body-parser')
```

The bodyParser table exposes various factories to create middlewares. All middlewares will populate the `req.body` property with the parsed body or an empty table (`{}`) if there was no body to parse (or an error was returned).

### `bodyParser.json(options)`

Returns middleware that only parses `json`.

### Options

The function takes an `options` table that may contain any of
the following keys:

- `limit` - controls the maximum request body size, specifies the number of bytes. Defaults to `100000` (~`100Kb`)

- `strict` - when set to `true`, will only accept arrays and objects; when `false` will accept anything `JSON.parse` accepts. Defaults to `true`.

- `type` - the `type` option is used to determine what media type the middleware will parse. Defaults to `application/json`.

### `bodyParser.urlencoded(options)`

Returns middleware that only parses urlencoded bodies.

### Options

The function takes an `options` table that may contain any of
the following keys:

- `limit` - controls the maximum request body size, specifies the number of bytes. Defaults to `100000` (~ `100Kb`)

- `type` - the `type` option is used to determine what media type the middleware will parse. Defaults to `application/x-www-form-urlencoded`.

### `bodyParser.text(options)`

Returns middleware that parses all bodies as a string.

### Options

The function takes an `options` table that may contain any of
the following keys:

- `limit` - controls the maximum request body size, specifies the number of bytes. Defaults to `100000` (~`100Kb`)

- `type` - the `type` option is used to determine what media type the middleware will parse. Defaults to `text/plain`.

## Examples

### Utopia top-level generic

This example demonstrates adding a generic JSON and URL-encoded parser as a top-level middleware, which will parse the bodies of all incoming requests. This is the simplest setup.

```lua
local json = requrie('json')
local Utopia = require('utopia')
local bodyParser = require('body-parser')

local app = Utopia:new()

-- parse application/x-www-form-urlencoded
app:use(bodyParser.urlencoded())

-- parse application/json
app:use(bodyParser.json())

app:use(function (req, res)
  res:finish('you posted: ' .. json.stringify(req.body, {indent = 2}))
end)

app:listen(3000)
```

### Change accepted type for parsers

All the parsers accept a type option which allows you to change the Content-Type that the middleware will parse.

```lua
-- parse various different custom JSON types as JSON
app:use(bodyParser.json({type = 'application/*+json'}))

-- parse some custom thing into a Buffer
app:use(bodyParser.raw({type = 'application/vnd.custom-type'}))

-- parse an HTML body into a string
app:use(bodyParser.text({type = 'text/html'}))
```

## License

MIT Licensed

Copyright (c) 2016 Dmitri Voronianski [dmitri.voronianski@gmail.com](mailto:dmitri.voronianski@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
