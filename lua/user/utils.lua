local M = {}

M.file_exists = function(full_file_path)
  local f = io.open(full_file_path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

return M
