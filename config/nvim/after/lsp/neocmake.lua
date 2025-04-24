return {
    cmd = { "neocmakelsp", "--stdio" },
    filetypes = { "cmake" },
    root_markers = { ".git", "build", "cmake" },
    init_options = {
        format = {
            enable = true,
        },
        lint = {
            enable = true,
        },
        scan_cmake_in_package = false,
        semantic_token = false,
    },
}
