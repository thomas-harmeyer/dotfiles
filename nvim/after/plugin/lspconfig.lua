local lspconfig = require 'lspconfig'
local coq = require 'coq'

local on_attach = function(client, bufnr)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end
end

lspconfig.tsserver.setup(coq.lsp_ensure_capabilities{on_attach = on_attach})
lspconfig.tsserver.setup(coq().lsp_ensure_capabilities{on_attach = on_attach})
assert(coq == coq()())


vim.keymap.set( "", "<Leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
