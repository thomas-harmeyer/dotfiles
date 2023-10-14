local api = require("sql.api")

Database = {}
Database.__index = Database
function Database.new(name)
  local self = setmetatable({}, Database)
  self.name = name
  self.children = {}
  self.open = false
  return self
end

function Database:addNode(tableName)
  local newTable = Table.new(tableName)
  print(newTable)
  table.insert(self.children, newTable)
end

function Database:clearNodes()
  self.children = {}
end

function Database:render()
  local openRender = self.open and "" or ""
  local stack = { openRender .. " " .. self.name }
  if self.open then
    for _, v in ipairs(self.children) do
      table.insert(stack, "  " .. v.name)
    end
  end
  return stack
end

function Database:handleOpen()
  local tables = api.get_tables(self.name)
  for _, v in ipairs(tables) do
    self:addNode(v)
  end
end
function Database:handleClose()
  self:clearNodes()
end

function Database:onAction(action)
  if action.type == "database" then
    if action.name == self.name then
      self.open = not self.open
      if self.open then
        self:handleOpen()
      else
        self:handleClose()
      end
    end
  else
    for _, v in ipairs(self.children) do
      v:onAction(action)
    end
  end
end

Table = {}
Table.__index = Table

function Table.new(name)
  local self = setmetatable({}, Table)
  self.name = name
  return self
end

function Table:render()
  return { self.name }
end

local function render() end

function Table:onAction(action)
  if action.type == "table" and action.name == self.name then
    print(self.name)
  end
end

return {
  Database = Database,
  Table = Table,
}
