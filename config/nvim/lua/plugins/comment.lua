return {
  "numToStr/Comment.nvim",
  opts = {
    toggler = {
      ---Line-comment toggle keymap, Control + /
      line = "<C-/>",
      ---Block-comment toggle keymap
      block = "<leader><C-/>",
    },
    opleader = {
      ---Line-comment keymap
      line = "<C-/>",
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
}
