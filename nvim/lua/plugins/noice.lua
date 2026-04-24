return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				opts = {
					background_colour = "#fafafa",
					timeout = 2500,
					render = "compact",
					stages = "static",
					top_down = false,
				},
			},
		},
		opts = {
			cmdline = {
				view = "cmdline_popup",
				format = {
					cmdline = { icon = ">" },
					search_down = { icon = "? " },
					search_up = { icon = "? " },
					filter = { icon = "$" },
					lua = { icon = "l" },
					help = { icon = "?" },
				},
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				hover = { enabled = true, silent = true },
				signature = { enabled = true },
				progress = { enabled = true },
				message = { enabled = true },
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = true,
			},
			routes = {
				{
					filter = { event = "msg_show", kind = "search_count" },
					opts = { skip = true },
				},
				{
					filter = { event = "msg_show", find = "written" },
					opts = { skip = true },
				},
				{
					filter = { event = "msg_show", find = "^:!" },
					view = "split",
				},
			},
		},
		keys = {
			{ "<leader>nd", "<cmd>NoiceDismiss<cr>", desc = "Dismiss notifications" },
			{ "<leader>nh", "<cmd>NoiceHistory<cr>", desc = "Noice history" },
			{ "<leader>nl", "<cmd>NoiceLast<cr>", desc = "Noice last message" },
			{
				"<c-f>",
				function()
					if not require("noice.lsp").scroll(4) then
						return "<c-f>"
					end
				end,
				silent = true,
				expr = true,
				mode = { "i", "n", "s" },
				desc = "Scroll forward",
			},
			{
				"<c-b>",
				function()
					if not require("noice.lsp").scroll(-4) then
						return "<c-b>"
					end
				end,
				silent = true,
				expr = true,
				mode = { "i", "n", "s" },
				desc = "Scroll back",
			},
		},
	},
}
