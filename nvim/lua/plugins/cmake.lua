return {
	"Civitasv/cmake-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
		cmake_compile_commands_options = {
			action = "soft_link",
			target = vim.fn.getcwd(),
		},
		cmake_regenerate_on_save = true,
	},
}
