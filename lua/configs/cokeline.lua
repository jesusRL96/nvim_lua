local get_hex = require("cokeline.hlgroups").get_hl_attr

local yellow = vim.g.terminal_color_3
require('cokeline').setup({
  mappings = {
    cycle_prev_next = true,
  },
  buffers = {
    filter_valid = function() return true end,
  },
  rendering = {
    max_buffer_width = 30,
  },
	default_hl = {
		fg = function(buffer)
			return buffer.is_focused and get_hex("Normal", "fg") or get_hex("Comment", "fg")
		end,
		bg = function()
			return get_hex("ColorColumn", "bg")
		end,
	},
  components = {
    {
      text = function(buffer)
        return buffer.is_focused and '' or ' '
      end,
      fg = function(buffer)
        return buffer.is_focused and '#3b4252' or nil
      end,
    },
    {
      text = function(buffer) return buffer.filename end,
      fg = function(buffer)
        return buffer.is_focused and '#ffffff' or '#808080'
      end,
      bg = function(buffer)
        return buffer.is_focused and '#3b4252' or nil
      end,
      style = function(buffer)
        return buffer.is_focused and 'bold' or nil
      end,
    },
    {
      text = function(buffer)
        return buffer.is_focused and '' or ' '
      end,
      fg = function(buffer)
        return buffer.is_focused and '#3b4252' or nil
      end,
    },
    {
      text = "󰅙",
      delete_buffer_on_left_click = true,
    },
    {
      text = function(buffer)
        return buffer.is_modified and "●" or " "
      end,
      fg = function(buffer)
        return buffer.is_modified and "#ff0000" or nil
      end,
    },
    {
      text = "  ",
    },
  }
})
