-- Git diff viewer
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "[G]it [D]iff (working tree)" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "[G]it file [H]istory" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "[G]it repo [H]istory" },
    { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "[G]it diff [Q]uit" },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { layout = "diff2_horizontal" },
      merge_tool = { layout = "diff3_mixed" },
    },
  },
}
