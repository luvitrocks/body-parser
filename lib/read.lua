local table = require('table')
local helpers = require('./helpers')

function read (req, nxt, opts, fn)
  if req._body then
    return nxt()
  end

  req.body = req.body or {}

  -- check if empty
  if not helpers.hasBody(req.headers) then
    return nxt()
  end

  -- check content-type
  if helpers.type(req.headers) ~= opts.type then
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

    -- parse body
    fn(buf)
  end)
end

return read
