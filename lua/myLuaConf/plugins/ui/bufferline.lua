return {
  {
    'bufferline.nvim',
    for_cat = 'general.extra',
    event = 'DeferredUIEnter',
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned buffers" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete Other buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete buffers to the left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    after = function()
      require('bufferline').setup({
        options = {
          mode = "buffers",
          themable = true,
          numbers = "none",
          -- Integration with edgy.nvim
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = "▎",
            style = "icon",
          },
          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 30,
          max_prefix_length = 30,
          truncate_names = true,
          tab_size = 21,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          show_duplicate_prefix = true,
          persist_buffer_sort = true,
          move_wraps_at_ends = false,
          separator_style = "slant",
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
          },
          sort_by = 'insert_after_current',
          groups = {
            options = {
              toggle_hidden_on_enter = true,
            },
            items = {
              {
                name = "Tests",
                highlight = {underline = true, sp = "blue"},
                priority = 2,
                icon = "",
                matcher = function(buf)
                  return buf.name:match('%_test') or buf.name:match('%_spec')
                end,
              },
              {
                name = "Docs",
                highlight = {underline = true, sp = "green"},
                auto_close = false,
                matcher = function(buf)
                  return buf.name:match('%.md') or buf.name:match('%.txt')
                end,
              },
            }
          }
        },
        highlights = {
          buffer_selected = { bold = true, italic = true },
          separator = { fg = 0 },
          fill = { bg = 0 },
          separator_visible = { fg = 0 },
          separator_selected = { fg = 0 } ,
        }
      })
    end,
  },
}
