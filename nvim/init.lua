vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.background = "light"
vim.opt.laststatus = 2
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildmenu = true
vim.opt.autoread = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.undofile = true
vim.opt.undodir = vim.fs.normalize("~/.config/nvim/undo") .. "//"
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.completeopt = { "menuone", "noinsert", "popup" }

vim.opt.shell = "/bin/sh"

require("vim._core.ui2").enable({
	enable = true,
	msg = {
		cmd = { height = 0.4 },
		msg = { timeout = 5000 },
	},
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	}):wait()
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({

	-- Theme
	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("onedark").setup({ style = "light" })
			require("onedark").load()
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "onedark",
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
			},
		},
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git files" },
			{ "<leader>fl", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Lines" },
			{ "<leader>fr", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
		},
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { preview_width = 0.5 },
			},
			pickers = {
				find_files = {
					hidden = true,
					file_ignore_patterns = { "%.git/" },
					find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
				},
			},
		},
	},

	-- Mason
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
			vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
		end,
	},
	{ import = "plugins" },

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = {
				cpp = { "clang-format" },
				c = { "clang-format" },
				h = { "clang-format" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				mdx = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				cmake = { "gersemi" },
			},
			format_on_save = {
				timeout_ms = 2000,
				lsp_format = "fallback",
			},
		},
	},

	-- Git signs
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Git
	{ "tpope/vim-fugitive" },

	-- Auto pairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},

	-- TODO comments
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufReadPost",
		opts = {},
		keys = {
			{ "<leader>tt", "<cmd>TodoTelescope<cr>", desc = "TODO list" },
		},
		args = { "--hidden" },
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local parsers = {
				"cpp",
				"cmake",
				"make",
				"python",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"yaml",
				"html",
				"css",
				"bash",
				"markdown",
				"markdown_inline",
				"latex",
				"vim",
				"lua",
				"regex",
			}
			require("nvim-treesitter").install(parsers)

			-- main branch: enable highlight + indent per-buffer (no auto-enable)
			local function ts_start(buf)
				local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
				if lang and pcall(vim.treesitter.start, buf, lang) then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					ts_start(args.buf)
				end,
			})
			-- catch buffers already loaded before this config ran (e.g. first file at launch)
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					ts_start(buf)
				end
			end
		end,
	},

	-- Auto-detect indent
	{ "tpope/vim-sleuth" },

	-- Neovim plugin testing
	{ "nvim-mini/mini.nvim", version = false },

	{
		"karb94/neoscroll.nvim",
		opts = {},
	},
	{
		dir = "/Users/artiehumphreys/plugins/sanitizer.nvim",
	},
}, {
	rocks = { enabled = false },
})

vim.diagnostic.config({
	virtual_text = true,
	virtual_lines = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		max_width = math.floor(vim.o.columns * 0.8),
		wrap = true,
		source = true,
	},
})

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
		end
		map("n", "gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "gr", vim.lsp.buf.references, "References")
		map("n", "gi", vim.lsp.buf.implementation, "Implementation")
		map("n", "K", vim.lsp.buf.hover, "Hover")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
		map("n", "<leader>d", vim.diagnostic.setloclist, "Diagnostics")
		map("n", "<leader>e", function()
			vim.diagnostic.open_float(nil, { scope = "line" })
		end, "Show diagnostic float")
		map("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", "Symbols")
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

-- As-you-type completion
-- Suppress re-popping right after a completion is accepted
local suppress_complete = false
vim.api.nvim_create_autocmd("CompleteDone", {
	callback = function()
		suppress_complete = true
	end,
})
vim.api.nvim_create_autocmd("InsertCharPre", {
	callback = function()
		suppress_complete = false
	end,
})
vim.api.nvim_create_autocmd("TextChangedI", {
	callback = function()
		if suppress_complete or vim.fn.pumvisible() == 1 then
			return
		end
		local line = vim.api.nvim_get_current_line()
		local col = vim.fn.col(".") - 1
		if line:sub(col, col):match("[%w_.]") then
			pcall(vim.lsp.completion.get)
		end
	end,
})

vim.api.nvim_set_hl(0, "SnippetTabstop", {})

-- Completion keymaps

local map = vim.keymap.set

map("n", "I", "i<Right>")
map("n", "H", "^")
map("i", "jj", "<Esc>")
map("n", "Q", "<cmd>b#<cr>", { silent = true })
map("n", "gt", "<cmd>bnext<cr>", { silent = true })
map("n", "gT", "<cmd>bprev<cr>", { silent = true })
map("n", "<leader>tn", "<cmd>tabnext<cr>", { silent = true })
map("n", "<leader>tp", "<cmd>tabprev<cr>", { silent = true })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { silent = true })
map("n", "<leader>lr", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return
	end
	for _, c in ipairs(clients) do
		c:stop()
	end
	-- wait for every client to fully exit before reloading, else the re-attach
	-- races the still-stopping client and native completion keeps a stale client id
	local timer = assert(vim.uv.new_timer())
	timer:start(
		50,
		50,
		vim.schedule_wrap(function()
			for _, c in ipairs(clients) do
				if not c:is_stopped() then
					return
				end
			end
			timer:stop()
			timer:close()
			vim.cmd.edit()
		end)
	)
end, { silent = true, desc = "Restart LSP" })
map("i", "<C-BS>", "<C-W>")
-- Cycle to next window and size it to 40% height
map("n", "<leader>w", function()
	vim.cmd.wincmd("w")
	vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.4))
end, { silent = true, desc = "Cycle window + 40% height" })
map("v", "<Tab>", ">gv")
map("v", "Y", '"+y')

-- Browse help via Telescope (select opens in new tab)
map("n", "<leader>fh", function()
	local builtin = require("telescope.builtin")
	local actions = require("telescope.actions")
	builtin.help_tags({
		attach_mappings = function()
			actions.select_default:replace(actions.select_tab)
			return true
		end,
	})
end, { desc = "Help tags" })

-- view C++ manpages via cppman, fuzzy finding with telescope
map("n", "<leader>fc", function()
	local cache = vim.fs.normalize("~/.cache/cppman/cppreference.com")
	local pages = {}
	for name, t in vim.fs.dir(cache) do
		if t == "file" then
			pages[#pages + 1] = name:gsub("%.3%.gz$", "")
		end
	end
	if #pages == 0 then
		vim.notify("No cppman pages cached; run `cppman -c`", vim.log.levels.WARN)
		return
	end
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	pickers
		.new({}, {
			prompt_title = "cppman",
			finder = finders.new_table({ results = pages }),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(bufnr)
				actions.select_default:replace(function()
					actions.close(bufnr)
					local sel = action_state.get_selected_entry()
					if not sel then
						return
					end
					local file = cache .. "/" .. sel[1] .. ".3.gz"
					local lines = vim.fn.systemlist("man " .. vim.fn.shellescape(file) .. " | col -bx")
					vim.cmd.tabnew()
					local buf = vim.api.nvim_get_current_buf()
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
					vim.bo[buf].filetype = "man"
					vim.bo[buf].modifiable = false
				end)
				return true
			end,
		})
		:find()
end, { desc = "cppman pages" })

map("n", "<leader>cc", function()
	local abs_path = vim.api.nvim_buf_get_name(0)
	local filename = vim.fs.basename(abs_path)
	local folder = vim.fs.basename(vim.fs.dirname(abs_path))

	vim.cmd("botright new")
	vim.api.nvim_win_set_height(0, math.floor(vim.o.lines / 4))
	vim.cmd.term("fish")
	vim.wo.wrap = true
	vim.fn.chansend(vim.b.terminal_job_id, "cfmake " .. folder .. " " .. filename .. "\n")
	vim.cmd.startinsert()
end, { desc = "Compile current file (cfmake)" })

map("n", "<leader>rf", function()
	local old_buf = vim.api.nvim_get_current_buf()
	local old_file = vim.api.nvim_buf_get_name(old_buf)

	vim.ui.input({ prompt = "New file path: ", default = old_file }, function(new_file)
		if not new_file or new_file == "" or new_file == old_file then
			vim.notify("Rename cancelled", vim.log.levels.INFO)
			return
		end
		if vim.uv.fs_stat(new_file) then
			vim.notify("Target already exists: " .. new_file, vim.log.levels.ERROR)
			return
		end

		vim.api.nvim_buf_set_name(old_buf, new_file)
		vim.api.nvim_buf_call(old_buf, function()
			vim.cmd.write({ bang = true })
		end)

		local success, err = vim.uv.fs_unlink(old_file)

		if success then
			vim.notify("Renamed to: " .. new_file, vim.log.levels.INFO)
		else
			vim.notify("Error deleting old file: " .. tostring(err), vim.log.levels.ERROR)
		end
	end)
end)

map("i", "<C-Space>", vim.lsp.completion.get, { desc = "Show completions" })

map("i", "<CR>", function()
	if vim.fn.pumvisible() == 0 then
		return "<CR>"
	end
	return vim.fn.complete_info().selected == -1 and "<C-n><C-y>" or "<C-y>"
end, { expr = true, desc = "Confirm completion" })

map("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-n>"
	elseif vim.snippet.active({ direction = 1 }) then
		return "<cmd>lua vim.snippet.jump(1)<cr>"
	end
	return "<Tab>"
end, { expr = true, desc = "Next item / snippet jump / tab" })

vim.cmd("iabbrev ;- —")

vim.cmd([[cnoreabbrev <expr> h getcmdtype() == ':' && getcmdline() ==# 'h' ? 'tab h' : 'h']])

vim.api.nvim_create_user_command("Cpy", function()
	vim.system({ "pbcopy" }, { stdin = vim.api.nvim_buf_get_lines(0, 0, -1, false) })
end, {})

vim.filetype.add({ extension = { mdx = "mdx" } })

-- Filetype settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "typescript", "typescriptreact", "mdx" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

-- Create parent dirs upon save if missing
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(ev)
		if ev.match:match("^%w%w+://") then
			return
		end
		local dir = vim.fs.dirname(vim.fs.abspath(ev.match))
		if not vim.uv.fs_stat(dir) then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- C/C++: 2-space indent, use cindent (treesitter cpp indent is flaky on newline)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "h" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.indentexpr = ""
	end,
})

-- C++ competitive programming template
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.cc",
	callback = function()
		local author = "Artie Humphreys"
		local ts = os.date("%Y.%m.%d %H:%M:%S")
		local header = {
			"/**",
			" *    author:  " .. author,
			" *    created: " .. ts,
			"**/",
			"",
		}
		vim.api.nvim_buf_set_lines(0, 0, 0, false, header)
		local tmpl = vim.fs.normalize("~/templates/template.cpp")
		if vim.uv.fs_stat(tmpl) then
			vim.api.nvim_buf_set_lines(0, 5, 5, false, vim.fn.readfile(tmpl))
		end
	end,
})

vim.opt.mouse = "a"
vim.opt.mousescroll = "ver:3,hor:6"
