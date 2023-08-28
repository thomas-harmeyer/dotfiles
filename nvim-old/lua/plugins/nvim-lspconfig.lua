return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      format = {
        timeout_ms = 15000,
      },
      servers = {
        pyright = {
          python = { analysis = { typeCheckingMode = "off" } },
        },
      },
    },
  },
}
