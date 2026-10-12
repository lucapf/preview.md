# Preview MD

Simple plugin to render your Markdown file.

## Usage:

Press `<leader>pp` will open a `pdf` version of your file using the default application configured in your laptop.

## Dependencies

* pandoc
* latex

## Installation:

Copy the content below inside the `~/.config/nvim/lua/plugins/md_preview.lua`

```
return {

  "lucapf/md_preview.vim",
  version  = "*",
  lazy = false,
  cmd = "Preview",
  init = function()
    vim.g.render_key = "<leader>pp"
  end,
  config = function()
    require("md_preview").setup({ key = "<leader>pp" })
  end,
}
```

Restart `neovim`
