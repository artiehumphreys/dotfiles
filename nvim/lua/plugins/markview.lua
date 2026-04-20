return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		filetypes = { "markdown", "mdx", "latex" },
		icon_provider = "devicons",
	},
}
