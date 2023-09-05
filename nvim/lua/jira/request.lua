local M = {}

local ltn12 = require 'ltn12'
local http = require 'socket.http'
local dkjson = require 'dkjson'

-- Set the URL and headers
local url = 'https://jira/rest/api/2/search'
local headers = {
  ['Content-Type'] = 'application/json',
}

-- Prepare params (JQL query)
local params = 'fields=summary,description&jql=assignee=currentUser()%20AND%20resolution=Unresolved'

-- Concatenate params to the URL
url = url .. '?' .. params

M.get_jira_tickets = function()
  -- Make the GET request
  local response_body = {}
  local _, code, _ = http.request {
    url = url,
    method = 'GET',
    headers = headers,
    sink = ltn12.sink.table(response_body),
  }

  -- Check HTTP response code
  if code == 200 then
    -- Parse JSON response to Lua table
    local response_str = table.concat(response_body)
    local obj, _, err = dkjson.decode(response_str, 1, nil)

    if err then
      print('Error:', err)
    else
      -- Loop through issues and print details
      -- for _, issue in ipairs(obj.issues) do
      --   print(issue.key ..
      --     ': ' .. issue.fields.summary .. ' (' .. (issue.fields.description or 'missing description') .. ')')
      -- end
      return obj.issues
    end
  else
    print('Failed: HTTP ' .. code)
  end
end

return M
