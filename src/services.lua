-- service management, again

rf.log(rf.prefix.green, "src/services")

do
  local svdir = "@[{os.getenv('SVDIR' or '/etc/rf/')}]"
  local sv = {up = nil}
  local running = {}
  local process = require("process")
  
  function sv.up(svc)
    if running[svc] then
      return true
    end
    local path = config[svc] and config[svc].file or
      string.format("%s.lua", svc)

  end
  
  function sv.down(svc)
    if not running[svc] then
      return true
    end
    local ok, err = process.kill(running[svc])
    if not ok then
      return nil, err
    end
    running[svc] = nil
    return true
  end
  
  function sv.list()
    return setmetatable({}, {
      __index = running,
      __pairs = running,
      __ipairs = running
    })
  end
  
  function sv.msg()
  end
  
  rf.log(rf.prefix.blue, "Starting services")
  for k, v in pairs(config) do
    if v.autostart then
      rf.log(rf.prefix.yellow, "service START: ", k)
      sv.up(k)
      rf.log(rf.prefix.yellow, "service UP: ", k)
    end
  end
end
