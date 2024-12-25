# Overview

`toc.nvim` is a Neovim plugin that allows users to navigate Markdown headings in the current buffer using a Telescope picker. With this plugin, you can quickly jump to any heading in your document, enhancing productivity and ease of navigation.

# Features

- Parse and list all Markdown headings in the current buffer.
- Seamless integration with Telescope for fuzzy searching.
- Instant navigation to the selected heading.
- User-friendly interface with customizable key mappings.

# Dependencies

- [Neovim (with lua support)](https://neovim.io/) >= 0.5
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

# Installation

To install the plugin using [lazy.nvim](https://github.com/folke/lazy.nvim), add the following configuration to your Neovim setup:

```lua
{
    'yousefakbar/toc.nvim',
    config = function()
        require('toc').setup()
    end
}
```

Otherwise, follow the specific steps for your plugin manager.

# Usage

1. Open a Markdown file in Neovim.
2. Run the command `:Toc` to open the Telescope picker with all the headings from the current buffer.
3. Use the fuzzy search functionality to find a heading.
4. Press `<Enter>` to navigate directly to the selected heading in the file.

# How It Works

1. **Heading Extraction**: The plugin scans the current buffer for Markdown headings (`#`, `##`, `###`, etc.) and organizes them in a table with their titles, line numbers, and levels.
2. **Telescope Integration**: The extracted headings are passed to Telescope, enabling users to search and select headings easily.
3. **Navigation**: Upon selecting a heading, the plugin jumps to the corresponding line in the document.

# Configuration

Currently, the plugin requires no additional configuration. However, you can extend its functionality or integrate it with your existing Neovim setup using the provided `setup` function.

# Contributing

Feel free to contribute to this project! Submit issues or pull requests on the [GitHub repository](https://github.com/yousefakbar/toc.nvim)
