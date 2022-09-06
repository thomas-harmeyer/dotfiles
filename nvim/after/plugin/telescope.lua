local actions = require("telescope.actions") -- for if you want telescope to do things
local builtin = require("telescope.builtin") -- for telescope functionallity 
local wk = require('which-key')

require("telescope").setup({
  extensions = {
    file_browser = {
      theme = 'dropdown',
      hijack_netrw = true
    }
  }
})
local file_browser = require("telescope").load_extension("file_browser")

wk.register({
  f = {
    name = "Telescope",
    f = { function() builtin.find_files() end, "Find Files" },
    g = { function() builtin.live_grep() end, "Live Grep" },
    b = { function() file_browser.file_browser() end, "File Browser"},
    u = { function() builtin.buffers() end, "Buffers" },
    h = { function() builtin.help_tags() end, "Help Tags" },
    d = { function() builtin.diagnostics() end, "Diagnostics" },
  }
}, {prefix = "<leader>"})

wk.register({
  g = {
    name = "Telescope LSP",
    r = { function() builtin.lsp_references() end, "References" },
    d = { function() builtin.lsp_definitions() end, "Definitions" },
    t = { function() builtin.lsp_type_definitions() end, "Type Definitions" },
    i = { function() builtin.lsp_implementations() end, "Implementations" },
  }
})
