return {
  {
    "yetone/avante.nvim",
    version = false,
    build = "make",
    -- Carga bajo demanda: solo al invocar un comando o un keymap de Avante
    cmd = {
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
      -- Específicos del provider ACP: elegir modelo de Claude y modo de permisos
      "AvanteACPModels",
      "AvanteACPModes",
    },
    keys = {
      { "<leader>aa", "<cmd>AvanteAsk<cr>", mode = { "n", "v" }, desc = "Avante: Ask" },
      { "<leader>ae", "<cmd>AvanteEdit<cr>", mode = "v", desc = "Avante: Edit" },
      { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante: Toggle Sidebar" },
      -- Cambio rápido de modelo: deepseek (API key) <-> claude-code (suscripción).
      -- :AvanteSwitchProvider no acepta argumentos (abre un selector), así que
      -- llamamos a la API directamente. El rawset es un workaround a un bug de
      -- avante: al cambiar a un provider ACP asigna Config.provider como campo
      -- directo (providers/init.lua:234), que ensombrece el metatable y hace
      -- fallar la vuelta con "Failed to find provider: claude-code".
      {
        "<leader>ad",
        function()
          rawset(require("avante.config"), "provider", nil)
          require("avante.api").switch_provider("openai")
        end,
        desc = "Avante: usar DeepSeek",
      },
      {
        "<leader>ac",
        function()
          rawset(require("avante.config"), "provider", nil)
          require("avante.api").switch_provider("claude-code")
        end,
        desc = "Avante: usar Claude Code",
      },
      { "<leader>ap", "<cmd>AvanteSwitchProvider<cr>", desc = "Avante: elegir provider" },
    },
    -- dressing.nvim (archivado, lo cubre snacks.input) y nvim-web-devicons
    -- (LazyVim usa mini.icons) se eliminaron por redundantes.
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      provider = "openai",
      providers = {
        openai = {
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
        auto_suggestions = false, -- <-- SOLO BAJO DEMANDA
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
      },

      mappings = {
        suggestion = {
          accept = "<M-l>", -- Aceptar sugerencia
          next = "<M-]>", -- Solicitar SUGERENCIA (esto la activa)
          prev = "<M-[>", -- Sugerencia anterior
          dismiss = "<C-]>", -- Descartar sugerencia
        },
      },

      -- Providers ACP: hablan con un binario local en vez de con una API HTTP,
      -- así que no necesitan API key propia.
      acp_providers = {
        ["claude-code"] = {
          -- El default de Avante apunta a "claude-agent-acp", que no existe en
          -- npm. El paquete real es @zed-industries/claude-code-acp y su
          -- binario se llama "claude-code-acp".
          command = "claude-code-acp",
          args = {},
          env = {
            NODE_NO_WARNINGS = "1",
            -- Reusa el binario `claude` ya autenticado con la suscripción.
            ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
            -- El default de Avante es "bypassPermissions" (edita sin
            -- preguntar); "default" pide confirmación antes de tocar archivos.
            ACP_PERMISSION_MODE = "default",
          },
        },
      },
    },
  },

  -- render-markdown ya viene del extra lang.markdown: solo añadimos el filetype de Avante
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
