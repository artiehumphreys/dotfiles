return {
	"Civitasv/cmake-tools.nvim",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		cmake_build_directory = "build",
		cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
		cmake_compile_commands_options = {
			action = "soft_link",
			target = vim.fn.getcwd(),
		},
		cmake_regenerate_on_save = true,
	},
	config = function(_, opts)
		local cmake = require("cmake-tools")
		cmake.setup(opts)

		-- Quick CMake Keybinds
		local map = vim.keymap.set
		map("n", "<leader>cg", "<cmd>CMakeGenerate<cr>", { desc = "CMake Generate" })
		map("n", "<leader>cb", "<cmd>CMakeBuild<cr>", { desc = "CMake Build" })
		map("n", "<leader>cr", "<cmd>CMakeRun<cr>", { desc = "CMake Run" })
		map("n", "<leader>ct", "<cmd>CMakeSelectBuildTarget<cr>", { desc = "Select Target" })
	end,
}
