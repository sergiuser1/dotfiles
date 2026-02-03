return {
  "numToStr/Comment.nvim",
  opts = {
    toggler = {
      ---Line-comment toggle keymap, Control + /
      line = "<C-_>",
      ---Block-comment toggle keymap
      block = "<leader><C-_>",
    },
    opleader = {
      ---Line-comment keymap
      line = "<C-_>",
    },
    -- Ignore empty lines
    ignore = "^$",
    post_hook = function(ctx)
      -- Check if it's not a line motion
      if ctx.cmotion > 1 then
        -- Set the visual range to the last comment range
        vim.fn.setpos("'<", { 0, ctx.range.srow, ctx.range.scol })
        vim.fn.setpos("'>", { 0, ctx.range.erow, ctx.range.ecol })
        vim.cmd([[exe "norm! gv"]])
      end
    end,
  },
  config = function(_, opts)
    require("Comment").setup(opts)

    -- Add Ctrl+/ as alternative (works in GUI/some terminals)
    local api = require("Comment.api")
    vim.keymap.set("n", "<C-/>", api.toggle.linewise.current, { desc = "Toggle comment" })
    vim.keymap.set(
      "v",
      "<C-/>",
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      { desc = "Toggle comment" }
    )
  end,
}
