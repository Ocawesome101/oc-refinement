-- service management, again

rf.log(rf.prefix.busy, "src/services")

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
  
  rf.log(rf.prefix.info, "Starting services")
  local start = {}
  for k, v in pairs(config) do
    if v.autostart then
      start[#start + 1] = k
    end
  end
end

rf.log(rf.prefix.done, "src/services")
