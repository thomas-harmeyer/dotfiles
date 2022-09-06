local lspconfig = require 'lspconfig'
local coq = require 'coq'

local on_attach = function(client, bufnr)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
end

lspconfig.tsserver.setup(coq.lsp_ensure_capabilities{on_attach = on_attach})
lspconfig.tsserver.setup(coq().lsp_ensure_capabilities{on_attach = on_attach})
assert(coq == coq()())


vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
