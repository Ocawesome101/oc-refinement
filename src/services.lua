-- service management --

rf.log(rf.prefix.busy, "src/services")

do
  local svdir = "@[{os.getenv('SVDIR') or '/etc/rf/'}]"

  local running = {}
  local sv = {up=true}
  
  local starting = {}
  sv.up = function(srv)
    checkArg(1, srv, "string")
    if starting[srv] then
      error("circular dependency detected")
    end
    local senv = setmetatable({needs=sv.up}, {__index=_G, __pairs=_G})
    local spath = string.format("%s/%s", svdir, srv)
    local ok, err = loadfile(svpath, nil, senv)
    if not ok then
      return nil, err
    end
    starting[srv] = true
    local st, rt = pcall(ok)
    if not st and rt then return nil, rt end
    if senv.start then pcall(senv.start) end
    running[srv] = senv
    return true
  end
  
  function sv.down(srv)
    checkArg(1, srv, "string")
    if not running[srv] then
      return true, "no such service"
    end
    if running[srv].stop then
      pcall(running[srv].stop)
    end
    running[srv] = nil
  end
  
  function sv.msg(srv, ...)
    checkArg(1, srv, "string")
    if running[srv] and running[srv].msg then
      return pcall(running[srv].msg, ...)
    end
    return true
  end
end

rf.log(rf.prefix.done, "src/services")
