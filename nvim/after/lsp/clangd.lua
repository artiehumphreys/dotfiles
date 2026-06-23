-- --experimental-modules-support makes clangd self-build C++20 modules from
-- compile_commands.json instead of loading CMake's prebuilt BMI
return {
	cmd = {
		"clangd",
		"--experimental-modules-support",
		"--log=error",
		"--clang-tidy",
		"--limit-references=100",
		"--limit-results=20",
		"--pch-storage=memory",
		"--header-insertion=iwyu",
	},
}
