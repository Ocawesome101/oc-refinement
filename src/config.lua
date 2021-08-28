local config = {}
do
  rf.log(rf.prefix.blue, "Loading service configuration")

  local fs = require("filesystem")
  local capi = require("config").bracket

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
    config = capi:load("/etc/rf.cfg")
  end
end
