local api = require("rust.builder.api")
local tag = require("rust.builder.tag")
local raw = require("rust.builder.raw")

return {
   [not OSX and not CURSES and 'cl' or 'ml'] = {
    -- Open this module for editing: `Alt/⌘-L` `M`
    s = { io.open_file,
        (_USERHOME..'/modules/rust/snippets.lua') },
  },

  ['s\n'] = function()
    buffer:line_end()
    buffer:add_text(';')
    buffer:new_line()
  end,

  ['a\n'] = function()
    buffer:line_end()
    buffer:new_line()
    buffer:add_text("/// ");
  end,


}
