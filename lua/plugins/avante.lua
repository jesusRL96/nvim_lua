-- Evita el error() sin pcall de avante al lanzar el ACP si falta el binario
local function claude_acp_available()
  return vim.fn.executable("claude") == 1 and vim.fn.executable("claude-code-acp") == 1
end

local function default_provider()
  if claude_acp_available() then return "claude-code" end
  vim.schedule(function()
    vim.notify(
      "Avante: falta `claude` y/o `claude-code-acp` (npm i -g @zed-industries/claude-code-acp). Usando DeepSeek.",
      vim.log.levels.WARN,
      { title = "Avante" }
    )
  end)
  return "openai"
end

return {
  {
    "yetone/avante.nvim",
    version = false,
    build = "bash build.sh", -- descarga binarios prebuilt; no requiere cargo
    cmd = { -- carga bajo demanda
      "AvanteAsk",
      "AvanteChat",
      "AvanteChatNew",
      "AvanteEdit",
      "AvanteToggle",
      "AvanteRefresh",
      "AvanteBuild",
      "AvanteStop",
      "AvanteClear",
      "AvanteHistory",
      "AvanteModels",
      "AvanteSwitchProvider",
      "AvanteACPModels", -- modelo de Claude (provider ACP)
      "AvanteACPModes", -- modo de permisos (provider ACP)
    },
    keys = {
      { "<leader>aa", "<cmd>AvanteAsk<cr>", mode = { "n", "v" }, desc = "Avante: Ask" },
      { "<leader>ae", "<cmd>AvanteEdit<cr>", mode = "v", desc = "Avante: Edit" },
      { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante: Toggle Sidebar" },
      {
        "<leader>ad",
        function()
          -- rawset: workaround a bug de avante al volver de un provider ACP
          rawset(require("avante.config"), "provider", nil)
          require("avante.api").switch_provider("openai")
        end,
        desc = "Avante: usar DeepSeek",
      },
      {
        "<leader>ac",
        function()
          if not claude_acp_available() then
            vim.notify("Avante: falta `claude` y/o `claude-code-acp` en el PATH", vim.log.levels.WARN, { title = "Avante" })
            return
          end
          rawset(require("avante.config"), "provider", nil)
          require("avante.api").switch_provider("claude-code")
        end,
        desc = "Avante: usar Claude Code",
      },
      { "<leader>ap", "<cmd>AvanteSwitchProvider<cr>", desc = "Avante: elegir provider" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      provider = default_provider(),
      providers = {
        openai = { -- DeepSeek
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-v4-pro",
          api_key_name = "DEEPSEEK_API_KEY",
          extra_request_body = {
            temperature = 0.7,
            max_tokens = 8192,
          },
        },
      },

      behaviour = {
        auto_suggestions = false, -- solo bajo demanda
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
      },

      mappings = {
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },

      acp_providers = {
        ["claude-code"] = {
          command = "claude-code-acp", -- @zed-industries/claude-code-acp
          args = {},
          env = {
            NODE_NO_WARNINGS = "1",
            ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
            ACP_PERMISSION_MODE = "default", -- pide confirmación antes de editar
          },
        },
      },
    },
  },

  -- añade el filetype de Avante al render-markdown del extra lang.markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = { "Avante" },
    opts = function(_, opts)
      opts.file_types = opts.file_types or { "markdown" }
      table.insert(opts.file_types, "Avante")
    end,
  },
}
