return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "ahmedkhalf/project.nvim",
  },
  config = function()
    -- Projects: detect a project root by these files/folders
    require("project_nvim").setup({
      detection_methods = { "pattern" },
      patterns = { ".git", "CMakeLists.txt", "Makefile", "package.json" },
    })

    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = "  ",
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
          width = 0.85,
          height = 0.8,
          preview_width = 0.55,
        },
      },
      pickers = {
        buffers = { theme = "dropdown", previewer = false },
        live_grep = { theme = "ivy" },
        grep_string = { theme = "ivy" },
      },
      extensions = {
        file_browser = {
          hijack_netrw = true,
          hidden = true,
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")
    telescope.load_extension("ui-select")
    telescope.load_extension("projects")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })

    vim.keymap.set("n", "<leader>fe", ":Telescope file_browser<CR>", { desc = "File browser" })
    vim.keymap.set("n", "<leader>fE", ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
      { desc = "File browser (current dir)" })

    vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Projects" })
  end,
}
