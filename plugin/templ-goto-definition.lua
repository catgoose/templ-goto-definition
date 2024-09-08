local g = vim.g

if g.templ_goto_definition == 1 then
  return
else
  g.templ_goto_definition = 1
end
