local Buffer = require('buffer').Buffer
local read = require('./read')

function parseRaw (opts)
  opts = opts or {}
  opts.limit = opts.limit or 100000 -- 100Kb
  opts.type = opts.type or 'application/octet-stream'

  return function (req, res, nxt)
    return read(req, nxt, opts, function (chunk)
      local buf = Buffer:new(chunk)

      req.body = buf

      nxt()
    end)
  end
end

return parseRaw
