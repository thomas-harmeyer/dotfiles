-- utils
local function trim(s)
  return s:match("^%s*(.-)%s*$")
end

local function string_to_table(str)
  local lines = {}
  for s in str:gmatch("[^\r\n]+") do
    table.insert(lines, trim(s))
  end
  return lines
end
--

local function get_databases()
  local databases = string_to_table(vim.fn.system([[sqlcmd -S dtdbuat -Q "select name from sys.databases"]]))
  table.remove(databases)
  table.remove(databases, 1)
  table.remove(databases, 1)
  return databases
end

local function get_tables(database)
  local tables = string_to_table(
    vim.fn.system(
      string.format(
        [[sqlcmd -S tradingserveruat -d %s -Q "SELECT s.name, t.name FROM sys.tables t INNER JOIN sys.schemas s ON t.schema_id = s.schema_id" -s "." -W]],
        database
      )
    )
  )
  table.remove(tables)
  table.remove(tables, 1)
  table.remove(tables, 1)
  print(vim.inspect(tables))
  return tables
end

local function get_rows(database, tbl)
  local rows = string_to_table(
    vim.fn.system(
      string.format([[sqlcmd -S tradingserveruat -d %s -Y 20 -y 20 -Q "SELECT TOP 1000 * FROM %s"]], database, tbl)
    )
  )
  return rows
end

local function exec_raw_cmd(cmd, opts)
  local y = opts.y or 20
  local database = opts.database or nil
  local args =
    { "-S tradingserveruat", string.format("-Y %d", y), string.format("-Y %d", y), string.format("-Q %s", cmd) }
  local query = "sqlcmd " .. table.concat(args, " ")
  return vim.fn.system(query)
end

return {
  get_databases = get_databases,
  get_tables = get_tables,
  get_rows = get_rows,
}
