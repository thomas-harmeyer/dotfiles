local dlsconfig = require 'diagnosticls-configs'

dlsconfig.init {
  -- Use a list of default configurations
  -- set by this plugin
  -- (Default: false)
  default_config = true,

  -- Set to false if formatting is not needed at all,
  -- any formatter provided will be ignored
  -- (Default: true)
  format = true,
}

dlsconfig.setup()
