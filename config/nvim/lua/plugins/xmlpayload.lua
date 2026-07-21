-- Parse a JSON message's payload field as formatted XML.
-- Usage:
--   :XmlPayload            -> extract .Payload from current buffer
--   :XmlPayload MessageId  -> extract a different field
--   Operates on the current buffer's contents (saved or not).
vim.api.nvim_create_user_command("XmlPayload", function(opts)
  local field = opts.args ~= "" and opts.args or "Payload"
  local input = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

  local out = vim.fn.systemlist({ "xmlpayload", "-f", field }, input)
  if vim.v.shell_error ~= 0 then
    vim.notify(table.concat(out, "\n"), vim.log.levels.ERROR)
    return
  end

  local src = vim.api.nvim_buf_get_name(0)
  local name = (src ~= "" and vim.fn.fnamemodify(src, ":r") or "payload") .. ".xml"

  vim.cmd("vsplit " .. vim.fn.fnameescape(name))
  vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
  vim.bo.filetype = "xml"
end, {
  nargs = "?",
  desc = "Pretty-print a JSON message payload field as XML",
})

vim.keymap.set("n", "<leader>xp", "<cmd>XmlPayload<cr>", { desc = "XML payload from JSON" })

return {}
