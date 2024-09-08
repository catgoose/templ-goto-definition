# templ-goto-definition

Fixes Neovim gopls LSP goto definition for templ templates

When using `vim.lsp.buf.definition` in a Go file for a templ template, gopls
only knows about the generated Go file. This plugin overrides `vim.lsp.buf.definition`
for the Go filetype and tries to open the correct temple file at the function
definition

## Setup

Lazy

```lua
return {
  "catgoose/templ-goto-definition",
  ft = { "go" },
  config = true,
}
```

See: <https://github.com/a-h/templ/issues/387>
