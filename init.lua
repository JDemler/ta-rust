--- the Textadept initializer for the Rust module
-- See @{README.md} for details on usage.
-- @author Alejandro Baez <alejan.baez@gmail.com>
-- @copyright 2014
-- @license MIT (see LICENSE)
-- @module init

textadept.editing.api_files.rust,
textadept.editing.autocompleters.rust = require("modules.rust.autocomplete")
local ua = require("modules/rust/api_builder")

local project_name, project_path = ua.get_project_name(io.get_project_root())
local user_api = project_path .. "/.api_" .. project_name

if project_name and io.open(user_api) then
  table.insert(textadept.editing.api_files.rust, user_api)
end

textadept.file_types.extensions.rs = 'rust'
textadept.editing.comment_string.rust = '//'

-- compiler
textadept.run.compile_commands.rust = 'rustc %(filename)'
textadept.run.run_commands.rust = '%d%(filename_noext)'

-- build project
textadept.run.build_commands[project_path] = function()
  ua.build_api(project_name, project_path)
  return "cargo build"
end

--- Table of Rust-specific key bindings.
-- @table keys.rust
-- @name _G.keys.rust
keys.rust = {
  [keys.LANGUAGE_MODULE_PREFIX] = {
    m = {io.open_file, _USERHOME..'/modules/rust/init.lua'},
  },
  ['s\n'] = function()
    buffer:line_end()
    buffer:add_text(';')
    buffer:new_line()
  end,

}

if type(snippets) == 'table' then
  snippets.rust = require("modules.rust.snippets")
end


events.connect(events.LEXER_LOADED, function (lang)
  if lang ~= 'rust' then return end

  buffer.tab_width = 4
  buffer.use_tabs = false
--  buffer.edge_column = 99
end)

return {}
