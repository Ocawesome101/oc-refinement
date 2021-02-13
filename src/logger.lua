-- logger --

do
  rf.prefix = {
    busy = "\27[34mbusy\27[39m ",
    info = "\27[34minfo\27[39m ",
    done = "\27[32mdone\27[39m ",
    fail = "\27[31mfail\27[39m ",
    warn = "\27[33mwarn\27[39m"
  }
  function rf.log(...)
    io.write(...)
    io.write("\n")
  end

  k.log(k.loglevels.info, "REFINEMENT HAS STARTED")
  rf.log(rf.prefix.info, "Starting ", rf._VERSION)
end
