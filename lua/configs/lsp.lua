-- lua/configs/lsp.lua
local M = {}

local function get_server_path(server_name)
  -- Check Mason install first
  local mason_path = vim.fn.stdpath('data') .. '/mason/bin/' .. server_name
  if vim.fn.executable(mason_path) == 1 then
    return mason_path
  end

  -- Check global install
  local global_path = vim.fn.exepath(server_name)
  if global_path ~= '' then
    return global_path
  end

  return nil
end

function M.setup()
  local lspconfig = require('lspconfig')
  local util = lspconfig.util

  -- Configure each server with explicit paths
  local servers = {
    ts_ls = {
      cmd = { get_server_path('typescript-language-server') or 'typescript-language-server', '--stdio' },
      filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      root_dir = util.root_pattern('package.json', 'tsconfig.json', '.git'),
      settings = {
        completions = { completeFunctionCalls = true }
      }
    },
    emmet_ls = {
      cmd = { get_server_path('emmet-ls') or 'emmet-ls', '--stdio' },
      filetypes = { 'html', 'css', 'scss', 'javascriptreact', 'typescriptreact' }
    },
    pyright = {
      cmd = { get_server_path('pyright-langserver') or 'pyright-langserver', '--stdio' },
      root_dir = util.root_pattern('pyproject.toml', 'setup.py', 'requirements.txt')
    },
    omnisharp = {
      cmd = { get_server_path('omnisharp') or 'omnisharp', '--languageserver' },
      root_dir = util.root_pattern('*.sln', '*.csproj')
    },
    rust_analyzer = {
      cmd = { get_server_path('rust-analyzer') or 'rust-analyzer' }
    },
    lua_ls = {
      cmd = { get_server_path('lua-language-server') or 'lua-language-server' },
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } }
        }
      }
    }
  }

  for server, config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_extend('force', {
      on_attach = M.on_attach,
      capabilities = M.capabilities,
    }, config))
  end
end

return M
