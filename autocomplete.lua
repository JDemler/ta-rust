--- autocomplete and api declaration.
-- @author [Alejandro Baez](https://twitter.com/a_baez)
-- @copyright 2015
-- @license MIT (see LICENSE)
-- @module autocomplete

local crates, config = require("modules.rust.config")

local _RUST = _USERHOME .. '/modules/rust/ta/'
local _RUSTSRC = "/data/Code/rust/src"

local tag_files = {}
local api_files = {}

for _, lib in ipairs(crates) do
  api_files[#api_files + 1] = _RUST .. 'api_' .. lib
  tag_files[#tag_files + 1] = _RUST .. 'tag_' .. lib
end

local XPM = textadept.editing.XPM_IMAGES
local xpms = setmetatable({
  c = XPM.VARIABLE, d = XPM.CLASS, f = XPM.METHOD, i = XPM.NAMESPACE,
  g = XPM.TYPEDEF, m = XPM.CLASS,  s = XPM.STRUCT, t = XPM.NAMESPACE,
  T = XPM.TYPEDEF
}, {__index = function(t, k) return 0 end})

--- potentially builds autocomplete using tags.
local function autocomplete()
  local list = {}
  print("AutoComplete: Save file...")
  local modified = buffer.modify
  if modified then
    print("Buffer Modified")
    io.save_file()
  end

  -- symbol behind caret
  local line, pos = buffer:get_cur_line()
  local part = line:sub(1, pos):match('([%w_]*)$')
  local lineNumber = buffer:line_from_position(buffer.current_pos) + 1
  local cmd = ("racer complete %d %d %s"):format(lineNumber, pos, buffer.filename)
  print(cmd)
  local f = io.popen(cmd)

  local sep = string.char(buffer.auto_c_type_separator)
  pattern = "MATCH ([%w_]+).*"
  for line in f:lines() do
    print(line)
    print("_______")
    if line:match(pattern) then
      sub, num_matches = line:gsub(pattern, "%1")
      list[#list + 1] = ("%s%s%d"):format(sub, sep, xpms["c"])
      list[sub] = true
    end
  end

  return #part, list
end

return {
  api_files = api_files,
  autocomplete = autocomplete,
}
