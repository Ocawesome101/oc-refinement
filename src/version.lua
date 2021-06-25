-- versioning --

do
  rf._NAME = "Refinement"
  rf._RELEASE = "1.05"
  rf._RUNNING_ON = "@[{os.getenv('OS')}]"
  
  io.write("\n  \27[97mWelcome to \27[93m", rf._RUNNING_ON, "\27[97m!\n\n")
  local version = "@[{os.date('%Y.%m.%d')}]"
  rf._VERSION = string.format("%s r%s-%s", rf._NAME, rf._RELEASE, version)
end
