local M = {}

local function get_pos(func)
  local ts_query = "(component_declaration name: (component_identifier) @func_name)"
  local ts_lang = "templ"
  local parser = vim.treesitter.get_parser(0, ts_lang)
  if not parser then
    return nil
  end
  local tstree = parser:parse()[1]
  local node = tstree:root()
  local query = vim.treesitter.query.parse(ts_lang, ts_query)
  for _, func_name_node in query:iter_captures(node, 0) do
    local func_name = vim.treesitter.get_node_text(func_name_node, 0)
    if func_name == func then
      local start_row, start_col, _ = func_name_node:start()
      return start_row, start_col
    end
  end
end

local function goto_definition(func)
  local row, col = get_pos(func)
  if not row or not col then
    vim.api.nvim_command("silent! /templ " .. func)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("0w", true, false, true), "n", false)
    return
  end
  vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

function M.setup()
  local group = vim.api.nvim_create_augroup("TemplGotoDefinition", { clear = true })
  vim.api.nvim_clear_autocmds({ group = group })
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "go", "templ" },
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
            local func = vim.fn.expand("<cword>")
            options.items[1].filename = prefix .. ".templ"
            vim.fn.setqflist({}, " ", options)
            vim.api.nvim_command("cfirst")
            goto_definition(func)
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

return M
