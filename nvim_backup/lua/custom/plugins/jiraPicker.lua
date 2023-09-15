local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values

local jira = function(opts)
	opts = opts or {}
	pickers
	    .new(opts, {
		    prompt_title = 'jira tickets',
		    finder = finders.new_table {
			    results = { 'red', 'green', 'blue' },
		    },
		    sorter = conf.generic_sorter(opts),
	    })
	    :find()
end

-- to execute the function
jira()
