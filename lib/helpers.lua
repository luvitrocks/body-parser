-- split string
function split (str, sep)
  sep = sep or '%s+'

  local result = {}
  local i = 1

  for value in str:gmatch('([^' .. sep .. ']+)') do
    result[i] = value
    i = i + 1
  end

  return result
end

function exports.hasBody (headers)
  return headers['transfer-encoding'] or headers['content-length'] and headers['content-length'] ~= 0
end

function exports.type (headers)
  local str = headers['content-type'] or ''

  return split(str, ';')[1]
end
