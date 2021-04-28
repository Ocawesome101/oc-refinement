-- shutdown override mkII

rf.log(rf.prefix.green, "src/shutdown")

do
  local computer = require("computer")
  local process = require("process")

  local shutdown = computer.shutdown

  function computer.shutdown(rbt)
    if process.info().owner ~= 0 then
      return nil, "permission denied"
    end

    rf.log(rf.prefix.red, "INIT: Stopping services")
    
    for svc, proc in pairs(rf.running) do
      rf.log(rf.prefix.yellow, "INIT: Stopping service: ", svc)
      process.kill(proc)
    end

    rf.log(rf.prefix.red, "INIT: Requesting system shutdown")
    shutdown(rbt)
  end
end
