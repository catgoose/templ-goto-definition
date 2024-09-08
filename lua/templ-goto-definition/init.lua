local M = {}

local function init()
  local group = vim.api.nvim_create_augroup("TemplGotoDefinition", { clear = true })
  vim.api.nvim_clear_autocmds({ group = group })
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "go" },
    group = group,
    callback = function()
      local lsp_def = vim.lsp.buf.definition
      local def_opts = {
        on_list = function(options)
          if options == nil or options.items == nil or #options.items == 0 then
            return
          end
          local targetFile = options.items[1].filename
          local prefix = string.match(targetFile, "(.-)_templ%.go$")
          if prefix then
            local function_name = vim.fn.expand("<cword>")
            options.items[1].filename = prefix .. ".templ"
            vim.fn.setqflist({}, " ", options)
            vim.api.nvim_command("cfirst")
            vim.api.nvim_command("silent! /templ " .. function_name)
            vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes("0w", true, false, true),
              "n",
              false
            )
          else
            lsp_def()
          end
        end,
      }
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.buf.definition = function(opts)
        opts = opts or {}
        opts = vim.tbl_extend("keep", opts, def_opts)
        lsp_def(opts)
      end
    end,
  })
end

init()

return M
