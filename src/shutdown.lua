-- shutdown override mkII

rf.log(rf.prefix.green, "src/shutdown")

do
  local computer = require("computer")
  local process = require("process")

  local shutdown = computer.shutdown

  function rf.shutdown(rbt)
    rf.log(rf.prefix.red, "INIT: Stopping services")
    
    for svc, proc in pairs(rf.running) do
      rf.log(rf.prefix.yellow, "INIT: Stopping service: ", svc)
      process.kill(proc, process.signals.kill)
    end

    if package.loaded.network then
      local net = require("network")
      if net.hostname() ~= "localhost" then
        rf.log(rf.prefix.red, "INIT: saving hostname")
        local handle, err = io.open("/etc/hostname", "w")
        if handle then
          handle:write(net.hostname())
          handle:close()
        end
      end
    end

    rf.log(rf.prefix.red, "INIT: Requesting system shutdown")
    shutdown(rbt)
  end

  function computer.shutdown(rbt)
    if process.info().owner ~= 0 then return nil, "permission denied" end
    rf._shutdown = true
    rf._shutdown_mode = not not rbt
  end
end
