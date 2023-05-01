local function disable(inputArray)
  local objects = {}
  for i = 1, #inputArray do
    objects[i] = { inputArray[i], enabled = false }
  end
  return objects
end

return disable({
  "rcarriga/nvim-notify",
  "stevearc/dressing.nviml",
  "akinsho/bufferline.nvim",
  "nvim-lualine/lualine.nvim",
  "folke/noice.nvim",
  "goolord/alpha-nvim",
})
