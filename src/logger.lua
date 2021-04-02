-- logger --

do
  rf.prefix = {
    red = "\27[91m*\27[97m ",
    blue = "\27[94m*\27[97m ",
    green = "\27[92m*\27[97m ",
    yellow = "\27[93m*\27[97m "
  }
  function rf.log(...)
    io.write(...)
    io.write("\n")
  end

  rf.log(rf.prefix.blue, "Starting \27[94m", rf._VERSION, "\27[97m")
end
