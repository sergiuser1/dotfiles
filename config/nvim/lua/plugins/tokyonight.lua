return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    light_style = "day",
    transparent = true,
    terminal_colors = false,
    styles = {
      sidebars = "transparent",
      -- floats = "transparent",
    },
    hide_inactive_statusline = false,
    dim_inactive = false,
    lualine_bold = false,
  },
}
