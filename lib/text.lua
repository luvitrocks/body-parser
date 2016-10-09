local qs = require('querystring')
local read = require('./read')

function parsePlainText (opts)
  opts = opts or {}
  opts.limit = opts.limit or 100000 -- 100Kb
  opts.type = opts.type or 'text/plain'

  return function (req, res, nxt)
    return read(req, nxt, opts, function (buf)
      req.body = buf
      nxt()
    end)
  end
end

return parsePlainText
