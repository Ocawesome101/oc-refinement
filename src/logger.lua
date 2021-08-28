-- logger --

do
  rf.prefix = {
    red = " \27[91m*\27[97m ",
    blue = " \27[94m*\27[97m ",
    green = " \27[92m*\27[97m ",
    yellow = " \27[93m*\27[97m "
  }

  local h,e=io.open("/sys/cmdline","r")
  if h then
    e=h:read("a")
    h:close()
    h=e
  end
  if h and h:match("bootsplash") then
    rf._BOOTSPLASH = true
    function rf.log(...)
      io.write("\27[G\27[2K", ...)
      io.flush()
    end
  else
    function rf.log(...)
      io.write(...)
      io.write("\n")
    end
  end

  rf.log(rf.prefix.blue, "Starting \27[94m", rf._VERSION, "\27[97m")
end
