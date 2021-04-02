-- service management, again

rf.log(rf.prefix.green, "src/services")

do
  local svdir = "@[{os.getenv('SVDIR' or '/etc/rf/')}]"
  local sv = {up = nil}
  local running = {}
  local process = require("process")
  
  function sv.up(svc)
  end
  
  function sv.down(svc)
  end
  
  function sv.list()
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
