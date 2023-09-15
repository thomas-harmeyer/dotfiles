-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- formatting lsp server
-- [[ DEFAULTS ]]
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- [[ PLUGINS ]]

-- JIRA
local jira = require("jira")
vim.keymap.set("n", "<leader>sj", function()
  jira.tickets()
end, { desc = "[S]earch [J]ira" })

-- SQL
local sql = require("sql")
vim.keymap.set("n", "<leader>Ss", function()
  sql.set_server()
end, { desc = "[S]ql set [S]erver" })

vim.keymap.set("n", "<leader>Sd", function()
  sql.set_database()
end, { desc = "[S]ql set [D]atabase" })

vim.keymap.set("n", "<leader>St", function()
  sql.set_table()
end, { desc = "[S]ql set [T]able" })

vim.keymap.set("n", "<leader>Sn", function()
  sql.do_next()
end, { desc = "[S]ql set [N]ext" })

vim.keymap.set("n", "<leader>Sr", function()
  sql.reset_all()
end, { desc = "[S]ql [R]eset" })

vim.keymap.set("n", "<leader>Sc", function()
  sql.write_columns()
end, { desc = "[S]ql write [C]olumns" })

vim.keymap.set("n", "<leader>Sp", function()
  sql.write_rows()
end, { desc = "[S]ql [P]rint Rows" })
