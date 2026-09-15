return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    -- Usamos `opts` como hook: lazy.nvim lo evalúa DESPUÉS de cargar el plugin
    -- y ANTES del `config` de LazyVim, así no pisamos su configuración
    -- (signos de breakpoint, mason-nvim-dap, soporte de launch.json).
    opts = function()
      local dap = require("dap")
      dap.configurations.python = dap.configurations.python or {}

      -- Añadimos (no reemplazamos) la config para adjuntarse a debugpy en Docker,
      -- para no borrar las configuraciones que registra nvim-dap-python.
      table.insert(dap.configurations.python, {
        type = "python",
        request = "attach", -- el debugger ya corre dentro del contenedor
        name = "Django: Attach to Docker",
        host = "localhost",
        port = 5678,
        justMyCode = false,
        pathMappings = {
          {
            -- ${workspaceFolder} se resuelve en tiempo de debug, no al arrancar
            localRoot = "${workspaceFolder}",
            -- Ruta del código dentro del contenedor; se puede sobreescribir por
            -- proyecto con la variable de entorno o con un .vscode/launch.json.
            remoteRoot = vim.env.NVIM_DAP_REMOTE_ROOT or "/usr/src/posi",
          },
        },
      })
    end,
  },
}
