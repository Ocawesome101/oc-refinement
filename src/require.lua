-- require function

rf.log(rf.prefix.green, "src/require")

do
  local loaded = package.loaded
  local loading = {}
  function _G.require(module)
    if loaded[module] then
      return loaded[module]
    elseif not loading[module] then
      local library, status, step
      
      step, library, status = "not found",
          package.searchpath(module, package.path)
      
      if library then
        step, library, status = "loadfile failed", loadfile(library)
      end
      
      if library then
        loading[module] = true
        step, library, status = "load failed", pcall(library, module)
        loading[module] = false
      end
      
      assert(library, string.format("module '%s' %s:\n%s",
          module, step, status))
      
      loaded[module] = status
      return status
    else
      error("already loading: " .. module .. "\n" .. debug.traceback(), 2)
    end
  end
end
