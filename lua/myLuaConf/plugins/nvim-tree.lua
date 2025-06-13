return {
  {
    "nvim-tree.lua",
    for_cat = 'general.file_navigation',
    event = "DeferredUIEnter",
    keys = {
      {"<C-n>", "<cmd>NvimTreeToggle<CR>", mode = {"n"}, noremap = true, desc = "Toggle nvim-tree"},
    },
    after = function(plugin)
      require('nvim-tree').setup({
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })
    end,
  },
}