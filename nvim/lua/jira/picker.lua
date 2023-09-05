local pickers = require 'telescope.pickers'
local previewer = require 'telescope.previewers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local request = require 'jira.request'

local M = {}

local function string_to_table(s)
  local t = {}
  for line in string.gmatch(s, '([^\r\n]+)') do
    table.insert(t, line)
  end
  return t
end

local get_jira_ticket_title = function(ticket)
  return ticket.key .. ' | ' .. (ticket.fields.summary or 'missing summary')
end

local get_jira_ticket_description = function(ticket)
  -- TODO: handle index
  local result = { ticket.key }
  local summary = string_to_table(ticket.fields.summary)
  local description = string_to_table(ticket.fields.description or '')
  for _, v in ipairs(summary) do
    table.insert(result, v)
  end
  for _, v in ipairs(description) do
    table.insert(result, v)
  end
  return result
end

M.tickets = function(opts)
  local jira_tickets = request.get_jira_tickets()
  opts = opts or {}
  local ticket_previewer = previewer.new_buffer_previewer {
    define_preview = function(self, entry, status)
      local ticket_description = get_jira_ticket_description(entry.value)
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, ticket_description)
    end,
    keep_last_buf = true,
  }
  pickers
      .new(opts, {
        prompt_title = 'jira tickets',
        finder = finders.new_table {
          results = jira_tickets,
          entry_maker = function(entry)
            return {
              value = entry,
              display = get_jira_ticket_title(entry),
              ordinal = get_jira_ticket_title(entry),
            }
          end,
        },
        sorter = conf.generic_sorter(opts),
        previewer = ticket_previewer,
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local last_bufnr = require('telescope.state').get_global_key 'last_preview_bufnr'
            vim.api.nvim_buf_set_option(last_bufnr, 'filetype', 'markdown')
            vim.api.nvim_set_current_buf(last_bufnr)
            vim.api.nvim_buf_set_option(last_bufnr, 'bufhidden', 'wipe')
            vim.cmd 'Glow'
          end)
          return true
        end,
      })
      :find()
end

return M
