-- versioning --

do
  rf._NAME = "Refinement"
  rf._RELEASE = "0"
  local version = "@[{os.date('%Y.%m.%d')}]"
  rf._VERSION = string.format("%s r%s-%s", rf._NAME, rf._RELEASE, version)
end
