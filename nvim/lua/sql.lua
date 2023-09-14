local pickers = require 'telescope.pickers'
local previewer = require 'telescope.previewers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local M = {}

local function string_to_table(s)
  local t = {}
  for line in string.gmatch(s, '([^\r\n]+)') do
    table.insert(t, line)
  end
  return t
end

local server = 'dtdbuat'
local db = ''
local tbl = ''

M.dbg = function()
  print(server, db, tbl)
end

local format_command = function(cmd, less, trim)
  if trim then
    cmd = cmd .. ' | tail -n +3 | head -n -2'
  end
  if less then
    cmd = cmd .. ' | less'
  end
  print(cmd)
  return cmd
end

local run_command = function(query, opts)
  opts = opts or {}
  local preview = opts.preview or false
  local less = opts.less or false
  local trim = opts.trim
  if trim == nil then
    trim = true
  end

  local cmd = string.format([[sqlcmd -S %s -d "%s" -Q "%s"]], server, db, query)
  if preview then
    cmd = cmd .. ' -Y 25' -- format
  else
    cmd = cmd .. ' -W' -- remove the whitespace
  end
  return format_command(cmd, less, trim)
end

local get_databases = function()
  return 'select name from sys.databases'
end

local get_tables = function()
  return 'select name from sys.tables'
end

local get_table_with_schema = function()
  local schema = vim.fn.system(run_command(
    string.format(
      [[
        SELECT s.name FROM sys.tables t
          INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = \"%s\"
      ]],
      tbl
    ),
    {}
  ))
  return schema .. '.' .. tbl
end

local get_columns = function()
  return string.format(
    [[select c.name, ty.name from sys.columns c
        join sys.tables t on c.object_id = t.object_id
        join sys.types ty on c.system_type_id = ty.system_type_id
      where t.name = \"%s\"]],
    tbl
  )
end

local get_rows = function(top)
  if top == nil then
    return string.format([[select * from %s]], get_table_with_schema())
  end
  return string.format([[select top %d * from %s]], top, get_table_with_schema())
end

M.set_server = function()
  server = vim.fn.input 'Server: '
end

M.set_database = function(opts)
  db = ''
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = 'databases',
      finder = finders.new_oneshot_job({ 'bash', '-c', run_command(get_databases(), {}) }, opts),
      sorter = conf.generic_sorter(opts),
      previewer = previewer.new_termopen_previewer {
        get_command = function(entry, status)
          db = entry[1]
          return { 'bash', '-c', run_command(get_tables(), { preview = true, less = true }) }
        end,
      },
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

M.set_table = function(opts)
  if db == '' then
    print 'missing db'
    return
  end
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = 'tables',
      finder = finders.new_oneshot_job({ 'bash', '-c', run_command(get_tables(), {}) }, opts),
      sorter = conf.generic_sorter(opts),
      previewer = previewer.new_termopen_previewer {
        get_command = function(entry, status)
          tbl = entry[1]
          return { 'bash', '-c', run_command(get_columns(), { preview = true, less = true }) }
        end,
      },
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

M.write_rows = function()
  if db == '' then
    print 'missing db'
    return
  end
  if tbl == '' then
    print 'missing tbl'
    return
  end
  local rows = string_to_table(vim.fn.system(run_command(get_rows(1000), { preview = true, trim = false })))

  local bufnr = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, rows)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_name(bufnr, 'Rows of ' .. tbl)
end

M.write_columns = function()
  if db == '' then
    print 'missing db'
    return
  end
  if tbl == '' then
    print 'missing tbl'
    return
  end

  local columns = string_to_table(vim.fn.system(run_command(get_columns(), { preview = true })))

  local bufnr = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, columns)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_name(bufnr, 'Columns of ' .. tbl)
end

M.do_next = function()
  if server == '' then
    M.set_server()
    return
  elseif db == '' then
    M.set_database()
    return
  elseif tbl == '' then
    M.set_table()
    return
  end

  print 'everything is set'
end

M.reset_all = function()
  db = ''
  tbl = ''
end

return M

-- vim: ts=2 sts=2 sw=2 et
