local M = {}

M.instance = nil

function M.setup()
  vim.api.nvim_create_user_command("InstallThings", function()
    print("test")
    if M.instance == nil then
      print("test 2")
      M.instance = require("banana.instance").newInstance("core", "installer")
      print("test 3")
      local el = M.instance:getElementById("input")
      print("test 4")

      local element_width = el:getWidth()
      local element_height = el:getHeight()
      local cell_width = 7
      local cell_height = 14
      print("test 5", element_width, element_height)

      local win_width = math.floor(element_width / cell_width)
      local win_height = math.floor(element_height / cell_height)
      print("test 6")

      local opts = {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = 0,
        col = 0,
        style = "minimal",
        border = "rounded",
      }

      local bufnr = vim.api.nvim_create_buf(false, true)
      print("test 7", bufnr)

      vim.bo[bufnr].modifiable = true
      vim.bo[bufnr].buftype = "" -- Clear 'nofile' buftype for normal editing
      print("test 8")

      local win_id = vim.api.nvim_open_win(bufnr, true, opts)
      vim.api.nvim_win_set_cursor(win_id, { 1, 1 })
      print("test 9", win_id)

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
