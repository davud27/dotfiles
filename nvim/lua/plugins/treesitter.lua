return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {}

    local langs = {
      'lua', 'rust', 'python', 'javascript', 'typescript', 'bash', 'markdown',
      'cpp', 'c', 'cmake', 'make',
    }

    require('nvim-treesitter').install(langs)

    local max_filesize = 100 * 1024 -- 100 KB

    vim.api.nvim_create_autocmd('FileType', {
      pattern = langs,
      callback = function(args)
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then
          return -- skip treesitter on huge files, just like the video's disable function
        end
        vim.treesitter.start()
        vim.bo[args.buf].syntax = 'off' -- equivalent to additional_vim_regex_highlighting = false
      end,
    })
  end,
}
