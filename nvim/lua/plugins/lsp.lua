return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {},
		},
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({ capabilities = capabilities })
				end,
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								workspace = {
									checkThirdParty = false,
									library = vim.api.nvim_get_runtime_file("", true),
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
				end,
			},
		})
	end,
}
