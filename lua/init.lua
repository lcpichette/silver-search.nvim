local M = {}

M.instance = nil

function M.setup()
  vim.api.nvim_create_user_command("InstallThings", function()
    if M.instance == nil then
      M.instance = require("banana.instance").newInstance("core", "installer")
      local el = M.instance:getElementById("input")
      el:attachRemap("n", "i", { "hover" }, function()
        local input = vim.fn.input("Input text: ")
        el:setTextContent(input)
      end, {})
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
