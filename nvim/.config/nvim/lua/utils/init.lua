local edgy_editor = require("edgy.editor")

local M = {}

function M.get_main_win()
  local wins = vim.tbl_values(edgy_editor.list_wins().main)

  -- sort by last enter time
  table.sort(wins, function(a, b)
    return (vim.w[a].edgy_enter or 0) > (vim.w[b].edgy_enter or 0)
  end)

  if #wins > 0 then
    return wins[1]
  end

  return 0
end

return M
