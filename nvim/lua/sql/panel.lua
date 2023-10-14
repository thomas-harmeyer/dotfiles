local panel = {}
local api = require("sql.api")
local classes = require("sql.classes")
local databases = {}

local function render_databases()
  local lines = {}
  for _, v in ipairs(databases) do
    for _, line in ipairs(v:render()) do
      table.insert(lines, line)
    end
  end
  vim.api.nvim_buf_set_lines(panel.buf, 0, -1, false, lines)
end

local function toggle()
  if panel.win == nil then
    local width = 65
    local height = vim.api.nvim_get_option("lines")
    local win = vim.api.nvim_open_win(panel.buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = 0,
      col = 0,
    })
    panel.win = win
  else
    vim.api.nvim_win_close(panel.win, false)
    panel.win = nil
  end
end

local function create()
  databases = api.get_databases()

  for i, v in ipairs(databases) do
    databases[i] = classes.Database.new(v)
  end

  panel.buf = vim.api.nvim_create_buf(false, true)

  render_databases()
  toggle()

  vim.keymap.set("n", "q", function()
    toggle()
  end, { buffer = panel.buf })
  vim.keymap.set("n", "<leader>v", function()
    toggle()
  end, { desc = "Open sq[v]" })
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local action
    if string.sub(line, 1, 2) == "  " then
      action = { type = "table", name = string.sub(line, 3) }
    else
      action = { type = "database", name = string.sub(line, 5) }
    end
    for _, v in ipairs(databases) do
      v:onAction(action)
    end
    render_databases()
    -- print(vim.inspect(databases))
  end, { buffer = panel.buf })
end

create()
