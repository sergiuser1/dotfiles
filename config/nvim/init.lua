-- Neovim

vim.deprecate = function() end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nvim-tree wants this. Why?
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Remove intro message
vim.opt.shortmess:append("I")

vim.opt.matchpairs:append("<:>")

-- [[ Spell checking ]]
-- `camel` splits CamelCase/mixedCase words so identifiers are checked
-- per-component, i.e. IFuckedUpSplling only flags "Splling"
vim.opt.spelllang = "en_gb"
vim.opt.spelloptions = "camel"
-- don't nag about lowercase sentence starts; comments rarely capitalise
vim.opt.spellcapcheck = ""
-- personal dictionary, kept in the dotfiles repo. `zg` adds a word, `zw`
-- marks one wrong, `zug`/`zuw` undo. Lowercase entries also match Utc/UTC.
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
vim.fn.mkdir(vim.fn.stdpath("config") .. "/spell", "p")

-- `zg` recompiles the word list itself, but editing the .add file by hand
-- leaves the compiled .spl stale, so rebuild it when the source is newer.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local add = vim.o.spellfile
    if vim.fn.getftime(add) > vim.fn.getftime(add .. ".spl") then
      pcall(vim.cmd, "silent mkspell! " .. vim.fn.fnameescape(add))
    end
  end,
})

-- Misspellings get a subtle underline rather than red, which is reserved for
-- actual errors. Re-applied on colourscheme changes since those reset it.
local function spell_highlights()
  local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
  for _, group in ipairs({ "SpellBad", "SpellCap", "SpellRare", "SpellLocal" }) do
    vim.api.nvim_set_hl(0, group, { undercurl = true, sp = comment.fg })
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = spell_highlights })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown", "text", "tex", "plaintex" },
  callback = function()
    vim.opt_local.spell = true
  end,
})


-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",
  space = " ",
  trail = "·",
  extends = ">",
  precedes = "<",
}

-- Enable diagnostics signs in the gutter
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Delete without yanking
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "d", '"_d')
vim.keymap.set("n", "D", '"_D')
vim.keymap.set("v", "d", '"_d')
vim.keymap.set("n", "c", '"_c')
vim.keymap.set("n", "s", '"_s')
vim.keymap.set("n", "C", '"_C')
vim.keymap.set("n", "Y", "y$")

-- Cut/copy to system clipboard
vim.keymap.set("n", "<leader>dd", '"+dd')
vim.keymap.set("n", "<leader>x", '"+x')
vim.keymap.set("n", "<leader>d", '"+d')
vim.keymap.set("n", "<leader>D", '"+D')
vim.keymap.set("v", "<leader>d", '"+d')
vim.keymap.set("n", "<leader>Y", ":%y<CR>")

-- Yank to system clipboard with common leading indentation stripped
-- (handy for pasting code into Teams/chat without extra whitespace)
vim.keymap.set("v", "<leader>y", function()
  local sline = vim.fn.line("v")
  local eline = vim.fn.line(".")
  if sline > eline then
    sline, eline = eline, sline
  end
  local lines = vim.fn.getline(sline, eline)
  local min_indent = math.huge
  for _, l in ipairs(lines) do
    if l:match("%S") then
      min_indent = math.min(min_indent, #l:match("^%s*"))
    end
  end
  if min_indent == math.huge then
    min_indent = 0
  end
  for i, l in ipairs(lines) do
    lines[i] = l:sub(min_indent + 1)
  end
  vim.fn.setreg("+", table.concat(lines, "\n"))
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  print(string.format("Dedent yank: %d line(s)", #lines))
end, { desc = "[Y]ank dedented to clipboard (Teams)" })

-- Search highlight toggle
vim.api.nvim_create_augroup("incsearch-highlight", { clear = true })
vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = "/,\\?",
  group = "incsearch-highlight",
  callback = function()
    vim.keymap.set("c", "<Tab>", "<C-G>")
    vim.keymap.set("c", "<S-Tab>", "<C-T>")
    vim.opt.hlsearch = true
  end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "/,\\?",
  group = "incsearch-highlight",
  callback = function()
    pcall(vim.keymap.del, "c", "<Tab>")
    pcall(vim.keymap.del, "c", "<S-Tab>")
  end,
})

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },

  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",

      -- Adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",
    },
  },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local function smart_filename()
        local winid = vim.g.statusline_winid or 0
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local full = vim.api.nvim_buf_get_name(bufnr)
        if full == "" then
          return "[No Name]"
        end
        local basename = vim.fn.fnamemodify(full, ":t")
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(b) and b ~= bufnr then
            local other = vim.api.nvim_buf_get_name(b)
            if vim.fn.fnamemodify(other, ":t") == basename and other ~= "" then
              return vim.fn.fnamemodify(full, ":~:.")
            end
          end
        end
        return basename
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_c = { smart_filename },
          lualine_x = { { "encoding", show_bomb = true }, "fileformat", "filetype" },
        },
        inactive_sections = {
          lualine_c = { smart_filename },
        },
        tabline = {
          lualine_a = { "buffers" },
          lualine_z = { "tabs" },
        },
      })
    end,
  },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = "ibl",
    opts = {},
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      -- Routes vim.ui.select (code actions, refactor menus, etc.) through a
      -- telescope window instead of the tiny bottom inputlist
      "nvim-telescope/telescope-ui-select.nvim",
    },
  },

  {
    -- Routes vim.ui.input (LSP rename, etc.) through a floating window
    -- instead of the plain command-line prompt. Only its input override is
    -- used -- vim.ui.select stays on telescope-ui-select above.
    "stevearc/dressing.nvim",
    opts = {
      input = { enabled = true },
      select = { enabled = false },
    },
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    build = function()
      require("nvim-treesitter").update()
    end,
  },

  {
    -- Sticky header showing the block(s) the cursor is inside
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 6, -- limit header height for deeply nested blocks
      multiline_threshold = 1, -- collapse each context line to a single line
    },
    keys = {
      {
        "[x",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Jump to context (enclosing block start)",
      },
    },
  },

  require("kickstart.plugins.debug"),

  {
    "nvimtools/none-ls.nvim",
  },

  {
    "folke/todo-comments.nvim",
    opts = function()
      -- The defaults only match SCREAMING keywords followed immediately by a
      -- colon, so `todo:` and `TODO(sero):` are both missed. Matching is forced
      -- case sensitive upstream (the regex is prefixed with \C), so lower/Title
      -- case spellings have to be registered as explicit aliases.
      local keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      }

      for name, keyword in pairs(keywords) do
        local spellings = { name }
        vim.list_extend(spellings, keyword.alt or {})

        local alt = keyword.alt or {}
        for _, spelling in ipairs(spellings) do
          table.insert(alt, spelling:lower())
          table.insert(alt, spelling:sub(1, 1) .. spelling:sub(2):lower())
        end
        keyword.alt = alt
      end

      return {
        signs = false,
        keywords = keywords,
        highlight = {
          -- keyword may be followed by an optional (author) or [author]
          pattern = [=[.*<((KEYWORDS)%(\s*[([][^)\]]*[)\]])?)\s*:]=],
        },
        search = {
          -- same as above, but ripgrep's regex needs `[` escaped inside a class
          pattern = [=[\b(KEYWORDS)(\s*[(\[][^)\]]*[)\]])?\s*:]=],
        },
      }
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
  },

  {
    "nvim-tree/nvim-web-devicons",
  },

  {
    "edgedb/edgedb-vim",
  },

  {
    "lambdalisue/suda.vim",
  },

  {
    "sindrets/diffview.nvim",
  },

  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_quickfix_ignore_filters = {
        "Marginpar on page",
        "Overfull",
        "Underfull",
        "overfull",
        "underfull",
        "citation",
      }
    end,
  },

  {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
    -- Must be `init`, not `config`: the plugin's own plugin/roslyn.lua calls
    -- vim.lsp.enable("roslyn"), which attaches to the already-open buffer while
    -- the plugin is sourced -- i.e. before `config` would run. Registering the
    -- settings in `init` guarantees the client starts with them.
    init = function()
      -- Enable navigating to decompiled sources (go-to-definition on
      -- external/NuGet/framework types shows real decompiled C# instead of
      -- metadata stubs), and let symbol search look in reference assemblies.
      vim.lsp.config("roslyn", {
        settings = {
          ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
          },
          ["navigation"] = {
            dotnet_navigate_to_decompiled_sources = true,
          },
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
        },
      })
    end,
    opts = {},
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Nsidorenco/neotest-vstest",
    },
    keys = {
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "[T]est [N]earest",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "[T]est [F]ile",
      },
      {
        "<leader>ta",
        function()
          -- Run every test in the project (cwd), not just the current file
          require("neotest").run.run(vim.uv.cwd())
          require("neotest").summary.open()
        end,
        desc = "[T]est [A]ll",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "[T]est [L]ast",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "[T]est [S]ummary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "[T]est [O]utput",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "[T]est [O]utput panel",
      },
      {
        "<leader>tx",
        function()
          require("neotest").run.stop()
        end,
        desc = "[T]est stop",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vstest"),
        },
        icons = {
          parameterized = "",
        },
        highlights = {
          parameterized = "NeotestNamespace",
        },
        status = {
          virtual_text = false,
        },
      })

      vim.fn.sign_define("neotest_parameterized", {
        text = "",
        texthl = "NeotestNamespace",
      })
    end,
  },
}, {})

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Rider-style auto write / auto read
-- Auto-reload files changed outside of nvim
vim.o.autoread = true
-- Auto-save when leaving insert mode, changing text, or losing focus
vim.o.autowriteall = true

vim.api.nvim_create_augroup("AutoReadWrite", { clear = true })

-- Fingerprint a file's contents ignoring only *insignificant* whitespace:
-- trailing whitespace, CR from CRLF endings, trailing blank lines, and a
-- leading BOM. Indentation is preserved so Python/YAML re-indents still count
-- as real changes. readfile() returns raw bytes, so the BOM must be stripped
-- by hand here -- Neovim only hides it from the *buffer*, not from readfile().
local function insignificant_whitespace_fingerprint(lines)
  local cleaned = {}
  for i, line in ipairs(lines) do
    cleaned[i] = (line:gsub("%s+$", ""))
  end

  if cleaned[1] then
    cleaned[1] = (cleaned[1]:gsub("^\239\187\191", ""))
  end

  for i = #cleaned, 1, -1 do
    if cleaned[i] == "" then
      cleaned[i] = nil
    else
      break
    end
  end

  return table.concat(cleaned, "\n")
end

local disk_state_cache = {}

-- Deliberate 'bomb'/'fileformat' toggles must count as real changes: the buffer
-- text is identical either way, so only the on-disk bytes reveal them.
local function disk_state(bufnr, path)
  local uv = vim.uv or vim.loop
  local stat = uv.fs_stat(path)
  if not stat then
    return nil
  end

  local key = string.format("%s:%d:%d:%d", path, stat.mtime.sec, stat.mtime.nsec, stat.size)
  local cached = disk_state_cache[bufnr]
  if cached and cached.key == key then
    return cached
  end

  local raw = vim.fn.readfile(path, "b")
  local first = raw[1] or ""
  local state = {
    key = key,
    fingerprint = insignificant_whitespace_fingerprint(raw),
    bomb = first:sub(1, 3) == "\239\187\191",
    fileformat = first:sub(-1) == "\r" and "dos" or "unix",
    empty = #raw == 0 or (#raw == 1 and first == ""),
  }

  disk_state_cache[bufnr] = state
  return state
end

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = "AutoReadWrite",
  callback = function(args)
    disk_state_cache[args.buf] = nil
  end,
})

local function has_only_whitespace_changes(bufnr)
  if vim.bo[bufnr].binary then
    return false
  end

  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" or vim.fn.filereadable(path) ~= 1 then
    return false
  end

  if vim.api.nvim_buf_line_count(bufnr) > 50000 then
    return false
  end

  local on_disk = disk_state(bufnr, path)
  if not on_disk then
    return false
  end

  if not on_disk.empty then
    if vim.bo[bufnr].bomb ~= on_disk.bomb or vim.bo[bufnr].fileformat ~= on_disk.fileformat then
      return false
    end
  end

  local in_buffer = insignificant_whitespace_fingerprint(vim.api.nvim_buf_get_lines(bufnr, 0, -1, true))
  return in_buffer == on_disk.fingerprint
end

-- Check for external changes on common events and reload if needed
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = "AutoReadWrite",
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Auto-save the current buffer (skip special/unnamed/readonly buffers)
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost" }, {
  group = "AutoReadWrite",
  pattern = "*",
  callback = function()
    if
      vim.bo.buftype == ""
      and vim.bo.modifiable
      and not vim.bo.readonly
      and vim.fn.expand("%") ~= ""
      and vim.bo.modified
    then
      if has_only_whitespace_changes(0) then
        vim.bo.modified = false
        return
      end

      vim.cmd("silent! write")
    end
  end,
})

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 100
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "gb", ":bnext<CR>")
vim.keymap.set("n", "gB", ":bprevious<CR>")

-- Window resize submode: enter it once, then tap the keys repeatedly instead of
-- respamming <C-w>. Any unhandled key (e.g. <Esc>) leaves the mode.
local resize_actions = {
  [">"] = "vertical resize +5",
  ["<"] = "vertical resize -5",
  ["+"] = "resize +3",
  ["-"] = "resize -3",
  ["="] = "wincmd =",
  ["|"] = "wincmd |",
  ["_"] = "wincmd _",
}

vim.keymap.set("n", "<leader>W", function()
  while true do
    vim.api.nvim_echo({
      { "-- RESIZE --", "ModeMsg" },
      { "  < > width   + - height   = equalise   | _ maximise   any other key exits" },
    }, false, {})

    local ok, key = pcall(vim.fn.getcharstr)
    vim.api.nvim_echo({}, false, {})
    if not ok or not resize_actions[key] then
      return
    end

    vim.cmd(resize_actions[key])
    vim.cmd("redraw")
  end
end, { desc = "[W]indow resize mode" })
--
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      timeout = 1000,
    })
  end,
  group = highlight_group,
  pattern = "*",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
  defaults = {
    path_display = { "smart" },
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")
-- Route vim.ui.select (code actions, refactors, etc.) through telescope
pcall(require("telescope").load_extension, "ui-select")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", function()
  -- Alt-based keys aren't reliably delivered by every terminal, so bind the
  -- buffer-delete action to Alt-free keys as well (<Tab> multi-select works too)
  require("telescope.builtin").buffers({
    attach_mappings = function(_, map)
      local actions = require("telescope.actions")
      map("n", "d", actions.delete_buffer)
      map("i", "<C-d>", actions.delete_buffer)
      return true
    end,
  })
end, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
-- Roslyn (and other pull-diagnostic servers) only publish diagnostics for open
-- files, so ask for solution-wide ones via workspace/diagnostic first
vim.keymap.set("n", "<leader>sd", function()
  require("telescope.builtin").diagnostics({ workspace = true, sort_by = "severity" })
end, { desc = "[S]earch [D]iagnostics (workspace)" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>gs", function()
  require("telescope.builtin").git_status({
    layout_config = { preview_width = 0.6 },
  })
end, { desc = "[G]it [S]tatus" })

-- [[ Configure Treesitter ]]
-- nvim-treesitter `main` branch (required for Neovim 0.12).
-- Parsers are installed imperatively; highlight/indent/fold are enabled per-buffer
-- via FileType autocmd.
local ts_parsers = {
  "c",
  "c_sharp",
  "lua",
  "python",
  "rust",
  "tsx",
  "javascript",
  "typescript",
  "vimdoc",
  "vim",
  "bash",
  "angular",
  "css",
  "html",
  "csv",
  "yaml",
  "jq",
  "json",
  "json5",
  "kotlin",
  "markdown",
  "markdown_inline",
  "passwd",
  "java",
  "regex",
  "sql",
  "ssh_config",
  "xml",
  "diff",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
}

local ts_ok, nts = pcall(require, "nvim-treesitter")
if ts_ok then
  local installed = {}
  for _, p in ipairs(nts.get_installed and nts.get_installed() or {}) do
    installed[p] = true
  end
  local missing = {}
  for _, p in ipairs(ts_parsers) do
    if not installed[p] then
      table.insert(missing, p)
    end
  end
  if #missing > 0 then
    nts.install(missing)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    -- tree-sitter-sql targets ANSI/Postgres/MySQL and has no grammar for T-SQL
    -- procedural syntax (BEGIN TRY/CATCH, THROW, GO batches, etc). It marks those
    -- regions as unparseable ERROR nodes with no highlight captures, leaving big
    -- chunks of real-world T-SQL files uncoloured. The legacy regex-based
    -- syntax/sql.vim doesn't need a full valid parse, so it colours much more
    -- reliably; mssql.nvim's LSP semantic tokens add T-SQL-specific colouring
    -- on top once connected.
    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
    if not lang or lang == "sql" then
      -- Force the legacy regex highlighter explicitly instead of hoping it's
      -- already active -- otherwise a stale/partial treesitter attachment
      -- (or a filetype-detection race) can leave the buffer under-coloured,
      -- unlike telescope's preview buffers which force this the same way.
      vim.bo[ev.buf].syntax = vim.bo[ev.buf].filetype
      return
    end
    if pcall(vim.treesitter.start, ev.buf, lang) then
      if vim.treesitter.query.get(lang, "indents") then
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})

local function clean_sql_compare_script(bufnr)
  bufnr = bufnr or 0
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd("silent! %s/\\r$//e")
    vim.cmd("retab")
  end)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local start_idx, end_idx
  for i, line in ipairs(lines) do
    if line:match("^%s*/%*") then
      start_idx = i
      break
    end
  end
  if start_idx then
    for i = start_idx, #lines do
      if lines[i]:match("%*/%s*$") then
        end_idx = i
        break
      end
    end
  end

  if start_idx and end_idx then
    local new_lines = {}
    for i = 1, start_idx - 1 do
      table.insert(new_lines, lines[i])
    end
    table.insert(new_lines, lines[start_idx])
    for i = start_idx + 1, end_idx - 1 do
      if lines[i]:match("^Script created by") then
        table.insert(new_lines, lines[i])
      end
    end
    table.insert(new_lines, lines[end_idx])
    for i = end_idx + 1, #lines do
      table.insert(new_lines, lines[i])
    end
    lines = new_lines
  end

  local final_lines = {}
  for i, line in ipairs(lines) do
    table.insert(final_lines, line)
    if line:match("^GO%s*$") and lines[i + 1] ~= nil and lines[i + 1] ~= "" then
      table.insert(final_lines, "")
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, final_lines)
end

vim.api.nvim_create_user_command("CleanSqlCompareScript", function()
  clean_sql_compare_script(0)
end, {})

-- nvim-treesitter-textobjects (main branch) — keymaps call functions directly.
local sel_ok, ts_select = pcall(require, "nvim-treesitter-textobjects.select")
local mov_ok, ts_move = pcall(require, "nvim-treesitter-textobjects.move")
local swp_ok, ts_swap = pcall(require, "nvim-treesitter-textobjects.swap")

if sel_ok then
  local map = function(lhs, capture)
    vim.keymap.set({ "x", "o" }, lhs, function()
      ts_select.select_textobject(capture, "textobjects")
    end, { desc = "TS select " .. capture })
  end
  map("aa", "@parameter.outer")
  map("ia", "@parameter.inner")
  map("af", "@function.outer")
  map("if", "@function.inner")
  map("ac", "@class.outer")
  map("ic", "@class.inner")
  map("ai", "@conditional.outer")
  map("ii", "@conditional.inner")
  map("ab", "@block.outer")
  map("ib", "@block.inner")
  map("al", "@loop.outer")
  map("il", "@loop.inner")
end

if mov_ok then
  local moves = {
    { "]m", "goto_next_start", "@function.outer" },
    { "]]", "goto_next_start", "@class.outer" },
    { "]M", "goto_next_end", "@function.outer" },
    { "][", "goto_next_end", "@class.outer" },
    { "[m", "goto_previous_start", "@function.outer" },
    { "[[", "goto_previous_start", "@class.outer" },
    { "[M", "goto_previous_end", "@function.outer" },
    { "[]", "goto_previous_end", "@class.outer" },
  }
  for _, m in ipairs(moves) do
    vim.keymap.set({ "n", "x", "o" }, m[1], function()
      ts_move[m[2]](m[3], "textobjects")
    end, { desc = "TS " .. m[2] .. " " .. m[3] })
  end
end

if swp_ok then
  vim.keymap.set("n", "<leader>a", function()
    ts_swap.swap_next("@parameter.inner")
  end, { desc = "TS swap next parameter" })
  vim.keymap.set("n", "<leader>A", function()
    ts_swap.swap_previous("@parameter.inner")
  end, { desc = "TS swap previous parameter" })
end

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader><CR>", vim.lsp.buf.code_action, "Space + Enter <3")
  nmap("<leader>ru", function()
    vim.lsp.buf.code_action({
      context = { only = { "source.removeUnused.ts" } },
      apply = true,
    })
  end, "[R]emove [U]nused")

  nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  nmap("ga", require("telescope.builtin").lsp_type_definitions, "[G]oto Type Definition [A]")

  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Breadcrumb: show the dotted path of the symbol/block the cursor is inside.
  nmap("<leader>bp", function()
    local params = { textDocument = vim.lsp.util.make_text_document_params() }
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, result)
      if err or not result or vim.tbl_isempty(result) then
        vim.notify("No symbol path found here", vim.log.levels.WARN)
        return
      end
      local parts = {}
      local function descend(symbols)
        for _, sym in ipairs(symbols) do
          local range = sym.range or (sym.location and sym.location.range)
          if range and range.start.line <= cursor_line and range["end"].line >= cursor_line then
            table.insert(parts, sym.name)
            if sym.children then
              descend(sym.children)
            end
            return
          end
        end
      end
      descend(result)
      if vim.tbl_isempty(parts) then
        vim.notify("No symbol path found here", vim.log.levels.WARN)
        return
      end
      local path = table.concat(parts, ".")
      vim.fn.setreg("+", path)
      vim.notify(path, vim.log.levels.INFO)
    end)
  end, "[B]readcrumb [P]ath (copy to clipboard)")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })

  -- Rider-style "highlight all usages of the symbol under the cursor"
  -- (textDocument/documentHighlight), driven off CursorHold so it kicks in
  -- automatically without needing to trigger a references search.
  if client:supports_method("textDocument/documentHighlight") then
    local group = vim.api.nvim_create_augroup("lsp-document-highlight-" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- document existing key chains
-- require("which-key").add({
--   { "<leader>c", group = "[C]ode" },
--   { "<leader>g", group = "[G]it" },
--   { "<leader>w", group = "[W]orkspace" },
-- })

require("mason").setup()

-- Per-server overrides. Any server installed via Mason is enabled automatically
-- (see automatic_enable below); these tables only add settings on top of
-- nvim-lspconfig's defaults. A server with an empty table just uses defaults.
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
        diagnostics = {
          globals = { "vim" },
        },
        telemetry = { enable = false },
      },
    },
  },
  pyright = {},
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = false, -- disable save-only checking
        diagnostics = {
          enable = true,
        },
      },
    },
  },
  yamlls = {
    root_markers = { ".git", "package.json", ".yaml-language-server" },
    settings = {
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
    },
  },
  lemminx = {
    settings = {
      xml = {
        symbols = {
          maxItemsComputed = 10000, -- Increase limit
          showReferencedGrammars = false,
        },
      },
    },
  },
  terraformls = {},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Global defaults applied to every server, plus per-server overrides above.
vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
})
for name, cfg in pairs(servers) do
  vim.lsp.config(name, cfg)
end

-- Ensure the servers above are installed and auto-enable every installed server.
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
  automatic_enable = true,
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

vim.cmd.colorscheme("tokyonight")

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
  },
})

-- Tree
-- nvim-tree has no built-in width persistence: it re-applies the configured
-- width on every open. Track the last size ourselves and feed it back.
local nvim_tree_width = 30

vim.api.nvim_create_autocmd("WinResized", {
  callback = function()
    local ok, api = pcall(require, "nvim-tree.api")
    if not ok then
      return
    end
    local win = api.tree.winid()
    if win and vim.api.nvim_win_is_valid(win) then
      nvim_tree_width = vim.api.nvim_win_get_width(win)
    end
  end,
})

require("nvim-tree").setup({
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    width = function()
      return nvim_tree_width
    end,
  },
})
vim.keymap.set("n", "<C-N>", function()
  require("nvim-tree.api").tree.toggle()
end)
vim.keymap.set("n", "<C-S-N>", function()
  require("nvim-tree.api").tree.find_file({ open = true, focus = true })
end)

-- When opening a file, go the last cursor position
vim.cmd([[
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
]])

vim.cmd([[
  aunmenu PopUp.How-to\ disable\ mouse
  aunmenu PopUp.-1-
]])

vim.cmd([[
  " set splitbelow
  set splitright
]])

vim.keymap.set("n", "<leader>yp", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  print("Copied: " .. path)
end, { desc = "[Y]ank relative [p]ath to clipboard" })

-- Remove trailing whitespace
vim.api.nvim_create_user_command("RmWhite", function()
  vim.cmd([[%s/\s\+$//e]])
end, {})

-- require("lspconfig").omnisharp.setup({
-- on_attach = on_attach,

-- settings = {
--   FormattingOptions = {
--         EnableEditorConfigSupport = true,
--         OrganizeImports = true,
--   },
-- RoslynExtensionsOptions = {
--   EnableAnalyzersSupport = true,
--   EnableImportCompletion = true,
--   AnalyzeOpenDocumentsOnly = false,
-- },
-- },
-- })

-- vim: ts=2 sts=2 sw=2 et
