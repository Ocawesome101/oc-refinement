-- Refinement init system. --
-- Copyright (c) 2021 i develop things under the DSLv1.

local rf = {}
--#include "src/version.lua"
--#include "src/logger.lua"
--#include "src/require.lua"
--#include "src/hostname.lua"
--#include "src/config.lua"
--#include "src/services.lua"
--#include "src/shutdown.lua"

while true do
  --local s = table.pack(
  coroutine.yield()
  --) if s[1] == "process_died" then print(table.unpack(s)) end
end
