P = function (v)
  print(vim.inspect(v))
  return v
end

RELOAD = function (...)
  return require("plenary.reload").reload_moule(...)
end

R = function (name)
  RELOAD(name)
  return require(name)
end
