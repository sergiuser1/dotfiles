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

-- Dotted path of the XML element under the cursor, e.g. Document.GrpHdr.MsgId
local function xml_path()
  local ok, parser = pcall(vim.treesitter.get_parser, 0, "xml")
  if not ok or not parser then
    return nil, "no xml treesitter parser for this buffer"
  end
  -- parse explicitly: the tree isn't guaranteed to be up to date unless the
  -- treesitter highlighter is already running on this buffer
  parser:parse()

  local node = vim.treesitter.get_node()
  if not node then
    return nil, "not inside an XML element"
  end

  local parts = {}
  while node do
    if node:type() == "element" then
      -- an element's name lives in its start tag (or the tag itself when empty)
      local tag = node:named_child(0)
      if tag then
        for child in tag:iter_children() do
          if child:type() == "Name" then
            table.insert(parts, 1, vim.treesitter.get_node_text(child, 0))
            break
          end
        end
      end
    end
    node = node:parent()
  end

  if #parts == 0 then
    return nil, "not inside an XML element"
  end
  return table.concat(parts, ".")
end

vim.api.nvim_create_user_command("XmlPath", function()
  local path, err = xml_path()
  if not path then
    vim.notify(err, vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", path)
  vim.fn.setreg('"', path)
  vim.notify(path)
end, { desc = "Yank dotted XML path of element under cursor" })

vim.keymap.set("n", "<leader>xy", "<cmd>XmlPath<cr>", { desc = "Yank XML path under cursor" })

return {}
