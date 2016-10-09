local json = require('json')
local read = require('./read')

function parseJson (opts)
  opts = opts or {}
  opts.limit = opts.limit or 100000 -- 100Kb
  opts.strict = opts.strict or true
  opts.type = opts.type or 'application/json'

  return function (req, res, nxt)
    return read(req, nxt, opts, function (buf)
      local firstChar = buf:sub(1, 1)

      -- http://www.rfc-editor.org/rfc/rfc7159.txt
      if opts.strict and firstChar ~= '[' or firstChar ~= '{' then
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
