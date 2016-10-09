function hasBody (headers)
  return headers['transfer-encoding'] or headers['content-length'] and headers['content-length'] ~= 0
end

return hasBody
