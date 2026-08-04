return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  opts = {
    provider = "openai",
    providers = {
      openai = {
        endpoint = "https://api.deepseek.com/v1",
        model = "deepseek-v4-flash",
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
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
  },
}
