return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = { "?.lua", "?/init.lua" },
						pathStrict = false,
					},
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME .. "/lua",
							vim.env.VIMRUNTIME .. "/lua/vim/_meta",
						},
						maxPreload = 2000,
						preloadFileSize = 1000,
					},
					diagnostics = {
						globals = { "vim", "MiniTest" },
						unusedLocalExclude = { "_*" },
						disable = { "no-unknown", "missing-fields", "incomplete-signature-doc" },
					},
					hint = {
						enable = true,
						setType = true,
						paramType = true,
						paramName = "All",
						semicolon = "Disable",
						arrayIndex = "Disable",
					},
					completion = { callSnippet = "Replace" },
					telemetry = { enable = false },
				},
			},
		})

		require("mason-lspconfig").setup({
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
				"neocmake",
				"autotools_ls",
			},
		})
	end,
}
