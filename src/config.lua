local config = {}
do
  rf.log(rf.prefix.blue, "Loading service configuration")

  -- string -> boolean, number, or string
  local function coerce(val)
    if val == "true" then
      return true
    elseif val == "false" then
      return false
    elseif val == "nil" then
      return nil
    else
      return tonumber(val) or val
    end
  end

  local fs = require("filesystem")
  if fs.stat("/etc/rf.cfg") then
    local section
    for line in io.lines("/etc/rf.cfg") do
      if line:match("%[.+%]") then
        section = line:sub(2, -2)
        config[section] = config[section] or {}
      else
        local k, v = line:match("^(.-) = (.+)$")
        if k and v then
          v = v:gsub("\n", "")
          if v:match("^%[.+%]$") then
            config[section][k] = {}
            for item in v:gmatch("[^%[%]%s,]+") do
              table.insert(config[section][k], coerce(item))
           end
          else
            config[section][k] = coerce(v)
          end
        end
      end
    end
  end
end
