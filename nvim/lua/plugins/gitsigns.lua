return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Jump between changed hunks
      map("]c", function() gs.nav_hunk("next") end, "Next hunk")
      map("[c", function() gs.nav_hunk("prev") end, "Prev hunk")

      -- Hunk actions
      map("<leader>gp", gs.preview_hunk, "Preview hunk")
      map("<leader>gs", gs.stage_hunk, "Stage hunk")
      map("<leader>gr", gs.reset_hunk, "Reset hunk")
      map("<leader>gS", gs.stage_buffer, "Stage file")
      map("<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
      map("<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")
      map("<leader>gd", gs.diffthis, "Diff file")
    end,
  },
}
