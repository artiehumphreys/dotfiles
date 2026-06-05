;extends

; C++20 modules: nvim-treesitter's cpp highlights don't capture these
["import" "export" "module"] @keyword.import
(module_name) @module
