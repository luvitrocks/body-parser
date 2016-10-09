local qs = require('querystring')
local read = require('./read')

function urlencoded (opts)
  opts = opts or {}
  opts.limit = opts.limit or 100000 -- 100Kb
  opts.type = opts.type or 'application/x-www-form-urlencoded'

  return function (req, res, nxt)
    return read(req, nxt, opts, function (buf)
      if #buf ~= 0 then
        req.body = qs.parse(buf)
      end

      nxt()
    end)
  end
end

return urlencoded
