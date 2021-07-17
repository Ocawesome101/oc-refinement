-- service management, again

rf.log(rf.prefix.green, "src/services")

do
  local svdir = "@[{os.getenv('SVDIR') or '/etc/rf/'}]"
  local sv = {}
  local running = {}
  rf.running = running
  local process = require("process")
  
  function sv.up(svc)
    local v = config[svc]
    if not v then
      return nil, "no such service"
    end
    if (not v.type) or v.type == "service" then
      rf.log(rf.prefix.yellow, "service START: ", svc)
      
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
      if ok then
        local pid = process.spawn {
          name = svc,
          func = ok,
        }
    
        running[svc] = pid
      end
  
      if not ok then
        rf.log(rf.prefix.red, "service FAIL: ", svc, ": ", err)
        return nil, err
      else
        rf.log(rf.prefix.yellow, "service UP: ", svc)
        return true
      end
    elseif v.type == "script" then
      rf.log(rf.prefix.yellow, "script START: ", svc)
      local file = v.file or svc
      
      if file:sub(1, 1) ~= "/" then
        file = string.format("%s/%s", svdir, file)
      end
      
      local ok, err = pcall(dofile, file)
      if not ok and err then
        rf.log(rf.prefix.red, "script FAIL: ", svc, ": ", err)
        return nil, err
      else
        rf.log(rf.prefix.yellow, "script DONE: ", svc)
        return true
      end
    end
  end
  
  function sv.down(svc)
    if not running[svc] then
      return true
    end
    
    local ok, err = process.kill(running[svc], process.signals.interrupt)
    if not ok then
      return nil, err
    end
    
    running[svc] = nil
    return true
  end
  
  function sv.list()
    local r = {}
    for k,v in pairs(running) do r[k] = v end
    return r
  end

  function sv.add(stype, name, file, ...)
    if config[name] then
      return nil, "service already exists"
    end

    local nent = {
      __load_order = {"autostart", "type", "file", "depends"},
      depends = table.pack(...),
      autostart = false,
      type = stype,
      file = file
    }
    table.insert(config.__load_order, name)
    config[name] = nent
    require("config").bracket:save("/etc/rf.cfg", config)
    return true
  end

  function sv.del(name)
    checkArg(1, name, "string")
    if not config[name] then
      return nil, "no such service"
    end
    config[name] = nil
    for k, v in pairs(config.__load_order) do
      if v == name then
        table.remove(config.__load_order, k)
        break
      end
    end
    require("config").bracket:save("/etc/rf.cfg", config)
    return true
  end
  
  function sv.enable(name)
    if not config[name] then
      return nil, "no such service"
    end
    config[name].autostart = true
    require("config").bracket:save("/etc/rf.cfg", config)
    return true
  end

  function sv.disable(name)
    if not config[name] then
      return nil, "no such service"
    end
    config[name].autostart = false
    require("config").bracket:save("/etc/rf.cfg", config)
    return true
  end

  package.loaded.sv = package.protect(sv)
  
  rf.log(rf.prefix.blue, "Starting services")
  for k, v in pairs(config) do
    if v.autostart then
      sv.up(k)
    end
  end

  rf.log(rf.prefix.blue, "Started services")
end
