-- requires environment variables

_G.main = function()
  local incl = (os.getenv "IMODS") or ""
  local include = {}
  for inc in incl:gmatch "[^,]+" do
    log("info", "including module ", inc)
    include[#include + 1] = inc
  end
  log("warn", "writing includes.lua")
  local handle = assert(io.open("includes.lua", "w"))
  for _,inc in ipairs(include) do
    handle:write(inc)
  end
  handle:close()
  ex(os.getenv("PREPROCESSOR") or "../utils/proc.lua", "init.lua refinement.lua")
  log("warn", "cleaning up")
  os.remove("includes.lua")
end
