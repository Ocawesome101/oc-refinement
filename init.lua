-- Refinement init system. --
-- Copyright (c) 2021 i develop things under the DSLv1.

local rf = {}
--#include "src/version.lua"
--#include "src/logger.lua"
--#include "src/hostname.lua"
--#include "src/config.lua"
--#include "src/services.lua"
--#include "src/shutdown.lua"

while true do
  if rf._shutdown then
    rf.shutdown(rf._shutdown_mode)
  end
  --local s = table.pack(
  coroutine.yield(2)
  --) if s[1] == "process_died" then print(table.unpack(s)) end
end
