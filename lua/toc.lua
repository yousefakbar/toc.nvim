local M = {}
-- local telescope = require "telescope.builtin"
local v = vim.api

M.setup = function()
  vim.keymap.set("n", "<leader>mc", M.TOC)
  vim.cmd[[command Toc :lua require('toc').TOC()]]
end

M.TOC = function()
  -- Get current buffer's contents
  local lines = v.nvim_buf_get_lines(0, 0, -1, false)

  -- Extract headings (#+) using regex on all the lines
  local headings = {}
  for i, line in ipairs(lines) do
    local hlvl, htxt = string.match(line, "^(#+) (.*)$")
    if hlvl then
      table.insert(headings, { title = htxt, line = i, level = #hlvl })
    end
  end

  -- If no headings are found, return early
  if #headings == 0 then
    print("No headings found!")
    return
  end

  -- Get the current window id for the markdown file
  local markdown_win = vim.api.nvim_get_current_win()

  local opts = {
    prompt_title = "Select Heading",
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
            print("Found title:", heading.title, "at line:", heading.line)
            -- Navigate to the selected heading
            vim.api.nvim_win_set_cursor(markdown_win, { heading.line, 0 })
            break
          end
        end

        actions.close(prompt_bufnr)
      end)
      return true
    end,
  }

  local pickers = require("telescope.pickers")
  pickers.new(opts):find()

end

return M
