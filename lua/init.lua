local M = {}

M.instance = nil

function M.setup()
  vim.api.nvim_create_user_command("InstallThings", function()
    if M.instance == nil then
      M.instance = require("banana.instance").newInstance("core", "installer")
      local el = M.instance:getElementById("input")

      local element_width = el:getWidth()
      local element_height = el:getHeight()
      local element_x = el:getX()
      local element_y = el:getY()
      local cell_width = 7
      local cell_height = 14

      local win_width = math.floor(element_width / cell_width)
      local win_height = math.floor(element_height / cell_height)
      local win_row = math.floor(element_y / cell_height)
      local win_col = math.floor(element_x / cell_width)

      local opts = {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = win_row,
        col = win_col,
        style = "minimal",
        border = "rounded", -- You can use "single", "double", "shadow", etc.
      }

      local bufnr = vim.api.nvim_create_buf(false, true)

      local win_id = vim.api.nvim_open_win(bufnr, true, opts)
      vim.api.nvim_win_set_cursor(win_id, { 1, 1 })

      local function on_buffer_change()
        print("Buffer content changed!")
        -- Retrieve and inspect the buffer's content
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        print(vim.inspect(lines))
      end

      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        callback = on_buffer_change,
        buffer = bufnr,
      })
    end

    M.instance:open()
  end, {})
end

function M.__banana_run(document)
  local container = document:getElementById("container")
  if #container:children() == 0 then
    document:loadNmlTo("list", container)
    M.selectTopNav("list-tb")
  end
end

return M
