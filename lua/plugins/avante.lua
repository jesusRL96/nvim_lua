return {
  {
    "yetone/avante.nvim",
    version = false,
    build = "make",
    -- Carga bajo demanda: solo al invocar un comando o un keymap de Avante
    cmd = { "AvanteAsk", "AvanteChat", "AvanteEdit", "AvanteToggle", "AvanteRefresh", "AvanteBuild" },
    keys = {
      { "<leader>aa", "<cmd>AvanteAsk<cr>", mode = { "n", "v" }, desc = "Avante: Ask" },
      { "<leader>ae", "<cmd>AvanteEdit<cr>", mode = "v", desc = "Avante: Edit" },
      { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante: Toggle Sidebar" },
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
