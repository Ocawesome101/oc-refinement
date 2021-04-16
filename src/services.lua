-- service management, again

rf.log(rf.prefix.green, "src/services")

do
  local svdir = "@[{os.getenv('SVDIR') or '/etc/rf/'}]"
  local sv = {}
  local running = {}
  local process = require("process")
  
  function sv.up(svc)
    if running[svc] then
      return true
    end
    if not config[svc] then
      return nil, "service not registered"
    end
    if config[svc].depends then
      for i, v in ipairs(config[svc].depends) do
        local ok, err = sv.up(v)
        if not ok then
          return nil, "failed starting dependency " .. v .. ": " .. err
        end
      end
    end
    local path = config[svc].file or
      string.format("%s.lua", svc)
    if path:sub(1,1) ~= "/" then
      path = string.format("%s/%s", svdir, path)
    end
    local ok, err = loadfile(path, "bt", _G)
    if not ok then
      return nil, err
    end
    local pid = process.spawn {
      name = svc,
      func = ok,
    }
    running[svc] = pid
    return true
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

  package.loaded.sv = package.protect(sv)
  
  rf.log(rf.prefix.blue, "Starting services")
  for k, v in pairs(config) do
    if v.autostart then
      if (not v.type) or v.type == "service" then
        rf.log(rf.prefix.yellow, "service START: ", k)
        local ok, err = sv.up(k)
        if not ok then
          rf.log(rf.prefix.red, "service FAIL: ", k, ": ", err)
        else
          rf.log(rf.prefix.yellow, "service UP: ", k)
        end
      elseif v.type == "script" then
        rf.log(rf.prefix.yellow, "script START: ", k)
        local file = v.file or k
        if file:sub(1, 1) ~= "/" then
          file = string.format("%s/%s", svdir, file)
        end
        local ok, err = pcall(dofile, file)
        if not ok and err then
          rf.log(rf.prefix.red, "script FAIL: ", k, ": ", err)
        else
          rf.log(rf.prefix.yellow, "script DONE: ", k)
        end
      end
    end
  end
  rf.log(rf.prefix.blue, "Started services")
end
