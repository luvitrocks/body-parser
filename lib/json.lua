local table = require('table')
local json = require('json')
local hasBody = require('./has-body')

function parseJson (opts)
  opts = opts or {}
  opts.strict = opts.strict or true
  opts.type = opts.type or 'application/json'

  return function (req, res, nxt)
    if req._body then
      return nxt()
    end

    req.body = req.body or {}

    if not hasBody(req.headers) then
      return nxt()
    end

    -- check content-type
    if req.headers['Content-Type'] ~= opts.type then
      return nxt()
    end

    -- mark as parsed
    req._body = true

    local body = {}
    local received = 0

    req:on('data', function (chunk)
      received = received + #chunk
      table.insert(body, chunk)
    end)

    req:on('end', function ()
      if opts.limit and type(opts.limit) == 'number' and received > opts.limit then
        return nxt({status = 413, msg = 'request entity too large'})
      end

      local buf = table.concat(body)
      local firstChar = buf:sub(1, 1)

      -- http://www.rfc-editor.org/rfc/rfc7159.txt
      if strict and firstChar ~= '[' or firstChar ~= '{' then
        return nxt({status = 400, msg = 'invalid json'})
      end

      if #buf == 0 then
        return nxt({status = 400, msg = 'invalid json, empty body'})
      end

      local parseStatus, result = pcall(json.parse, buf)

      if not parseStatus then
        return nxt({status = 400, msg = result})
      end

      req.body = result

      nxt()
    end)
  end
end

return parseJson
