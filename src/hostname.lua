-- set the system hostname, if possible --

rf.log(rf.prefix.green, "src/hostname")

if package.loaded.network then
  local handle, err = io.open("/etc/hostname", "r")
  if not handle then
    rf.log(rf.prefix.red, "cannot open /etc/hostname: ", err)
  else
    local data = handle:read("a"):gsub("\n", "")
    handle:close()
    rf.log(rf.prefix.blue, "setting hostname to ", data)
    package.loaded.network.sethostname(data)
  end
end
