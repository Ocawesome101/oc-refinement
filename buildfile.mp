-- requires environment variables

_G.main = () ->
  incl = (os.getenv "IEXTRA") or ""
  include = {}
  for inc in incl\gmatch "[^,]+" do
    log "info", "including module ", inc
    include[#include + 1] = inc
  log "warn", "writing includes.lua"
  handle = assert io.open "includes.lua", "w"
  for inc in *include do handle\write inc
  handle\close!
  io.write ex "./luacomp init.lua -Orefinement.lua"
  log "warn", "cleaning up"
  os.remove "includes.lua"
