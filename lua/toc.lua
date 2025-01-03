local M = {}
local v = vim.api

-- Make sure this module is only ever read once
if vim.g.loaded_toc then
  return
end
vim.g.loaded_toc = true

M.setup = function()
  vim.cmd[[command Toc :lua require('toc').TOC()]]
end

-- `get_headings` scans and returns a table of headings found in `lines`
local get_headings_cur_buf = function()
  local lines = v.nvim_buf_get_lines(0, 0, -1, false)
  local headings = {}
  for i, line in ipairs(lines) do
    local hlvl, htxt = string.match(line, "^(#+) (.*)$")
    if hlvl then
      table.insert(headings, { title = htxt, line = i, level = hlvl })
    end
  end
  return headings
end

local dispatch_telescope_headings = function(headings, win)
  local opts = {
    prompt_title = "📖 Select Heading",
    finder = require('telescope.finders').new_table({
      results = vim.tbl_map(function(heading) return heading.title end, headings)  -- Map titles to the results list
    }),
    sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      map('i', '<CR>', function()
        local selection = require('telescope.actions.state').get_selected_entry()
        local heading_title = selection[1]

        -- Find the selected heading in the headings list
        for _, heading in ipairs(headings) do
          if heading.title == heading_title then
            -- Navigate to the selected heading
            v.nvim_win_set_cursor(win, { heading.line, 0 })
            break
          end
        end

        actions.close(prompt_bufnr)
        vim.cmd[[normal zz]]
      end)
      return true
    end,
  }

  -- local pickers = require("telescope.pickers")
  require("telescope.pickers").new(opts):find()
end

M.TOC = function()
  -- Get current buffer's headings if any
  local headings = get_headings_cur_buf()

  -- If no headings are found, return early
  if #headings == 0 then
    print("No headings found!")
    return
  end

  -- Dispatch the headings to Telescope for search and select
  dispatch_telescope_headings(headings, v.nvim_get_current_win())
end

return M
