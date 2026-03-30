-- Leader key
vim.g.mapleader = "/"
vim.g.maplocalleader = "/"

-- General Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.background = "light"
vim.opt.laststatus = 2
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.wildmenu = true
vim.opt.autoread = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo//")
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250

vim.g.python3_host_prog = "/opt/homebrew/opt/python@3.13/libexec/bin/python"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
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
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Files" },
			{ "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>g", "<cmd>Telescope git_files<cr>", desc = "Git files" },
			{ "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Lines" },
			{ "<C-f>", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
		},
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { preview_width = 0.5 },
			},
		},
	},

	-- Mason
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"clangd",
				"ts_ls",
				"jsonls",
				"yamlls",
				"html",
				"cssls",
				"eslint",
				"pyright",
				"lua_ls",
				"bashls",
			},
		},
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = {
				cpp = { "clang-format" },
				c = { "clang-format" },
				h = { "clang-format" },
				hpp = { "clang-format" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				lua = { "stylua" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
			},
			format_on_save = {
				timeout_ms = 500,
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

	-- Surround
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {},
	},

	-- Commenting
	{
		"numToStr/Comment.nvim",
		opts = {},
	},

	-- Auto pairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local autopairs = require("nvim-autopairs")
			autopairs.setup({})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},

	-- Floating terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			direction = "float",
			float_opts = {
				border = "curved",
				width = function()
					return math.floor(vim.o.columns * 0.4)
				end,
				height = function()
					return math.floor(vim.o.lines * 0.4)
				end,
			},
		},
		keys = {
			{ "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
			{ "<leader>tt", "<cmd>ToggleTerm<cr>", mode = "t", desc = "Toggle terminal" },
			{ "<leader>tk", "<cmd>ToggleTerm<cr>", desc = "Kill terminal" },
		},
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c",
					"cpp",
					"cmake",
					"python",
					"javascript",
					"typescript",
					"tsx",
					"json",
					"yaml",
					"html",
					"css",
					"lua",
					"vim",
					"markdown",
					"bash",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- Auto-detect indent
	{ "tpope/vim-sleuth" },

	{
		"karb94/neoscroll.nvim",
		opts = {},
	},
})

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
		end
		map("n", "gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "gr", vim.lsp.buf.references, "References")
		map("n", "gi", vim.lsp.buf.implementation, "Implementation")
		map("n", "K", vim.lsp.buf.hover, "Hover")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
		map("n", "<leader>d", vim.diagnostic.setloclist, "Diagnostics")
		map("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", "Symbols")
	end,
})

-- LSP server configs
vim.lsp.config("*", {})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},
			diagnostics = { globals = { "vim" } },
			completion = { callSnippet = "Replace" },
			telemetry = { enable = false },
		},
	},
})

vim.lsp.enable({
	"clangd",
	"ts_ls",
	"jsonls",
	"yamlls",
	"html",
	"cssls",
	"eslint",
	"pyright",
	"lua_ls",
	"bashls",
})

-- Keymaps
local map = vim.keymap.set

map("n", "X", "xi")
map("n", "I", "i<Right>")
map("n", "H", "^")
map("i", "jj", "<Esc>")
map("n", "Q", ":b#<CR>", { silent = true })
map("n", "gt", ":bnext<CR>", { silent = true })
map("n", "gT", ":bprev<CR>", { silent = true })
map("i", "<C-BS>", "<C-W>")
map("n", "<leader>w", "<C-w>w")
map("v", "<Tab>", ">gv")

vim.api.nvim_create_user_command("Cpy", function()
	vim.cmd("%w !pbcopy")
	vim.cmd("redraw!")
end, {})

-- Filetype settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "typescript", "typescriptreact", "mdx" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
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
		vim.cmd("5r " .. vim.fn.expand("~/templates/template.cpp"))
	end,
})

-- vim-like scrolling support
vim.opt.mouse = "a"
vim.opt.mousescroll = "ver:3,hor:6"
