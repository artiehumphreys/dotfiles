return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown", "mdx" },
	opts = {
		file_types = { "markdown", "mdx" },
		heading = {
			sign = false,
			width = "block",
			left_pad = 1,
			right_pad = 2,
		},
		code = {
			sign = false,
			width = "block",
			border = "thin",
			left_pad = 1,
			right_pad = 2,
		},
		bullet = { icons = { "•", "◦", "▸", "▹" } },
		checkbox = {
			unchecked = { icon = "󰄱 " },
			checked = { icon = "󰱒 " },
		},
	},
}
