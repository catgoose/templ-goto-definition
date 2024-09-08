# templ-goto-definition

Fixes Neovim gopls LSP goto definition for templ templates

When using `vim.lsp.buf.definition` in a Go file for a templ template, gopls
only knows about the generated Go file. This plugin overrides `vim.lsp.buf.definition`
for the Go filetype and tries to open the correct temple file at the function
definition

`templ` treesitter grammar is required for treesitter query to locate function name
in .templ file. If treesitter is unavailable, text search strategy is used

## Setup

Lazy.nvim

```lua
return {
  "catgoose/templ-goto-definition",
  ft = { "go" },
  config = true,
  dependenciies = "nvim-treesitter/nvim-treesitter", -- optional
}
```

See: <https://github.com/a-h/templ/issues/387>
