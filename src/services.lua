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

  rf.log(rf.prefix.info, "Starting services")

  local config = {}
  local fs = require("filesystem")
  if fs.stat("/etc/rf.cfg") then
    local section
    for line in io.lines("/etc/rf.cfg") do
      if line:match("%[.+%]") then
        section = line:sub(2, -2)
        config[section] = config[section] or {}
      else
        local k, v = line:match("^(.-) = (.+)$")
        if v:match("^%[.+%]$") then
          config[section][k] = {}
          for item in v:gmatch("[^%[%]%s,]+") do
            table.insert(config[section][k], tonumber(item) or item)
          end
        else
          config[section][k] = v
        end
      end
    end
  end
end

rf.log(rf.prefix.done, "src/services")
