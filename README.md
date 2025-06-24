# 🍳 cook.nvim

**cook.nvim** is a modular and extensible Neovim plugin that lets you effortlessly compile or run the current file based on its filetype — inside a floating terminal.

### default runner based on file extension

![default-cook-demo](https://github.com/user-attachments/assets/9564866f-8345-4b3f-9a5d-73b5de85676d)

### custom project recipes

![recipes-cook-demo](https://github.com/user-attachments/assets/cb05b37e-b741-4928-883c-26a8780f05f8)

### `:Coop` auto paste the clipboard, helpful for Competetive Programming

![coop-cook-demo](https://github.com/user-attachments/assets/fe9dc656-0c1c-4206-84a0-7767f20ef92f)

Supports:

- 🐍 Python
- 🦀 Rust
- 🧠 C/C++
- 🌀 JavaScript / TypeScript
- 🦫 Go

## ✨ Features

- 📂 Runs code from the current buffer based on its extension
- 🪟 Opens a floating terminal inside Neovim
- ⚙️ Easily extendable for any language
- 📦 Define per-project tasks with `recipes.lua`
- 🧠 Smart filetype-to-runner resolution
- 📋 `:Coop` mode for Competitive Programming
- ❗ Tasks starting with `!` run as native Vim commands — useful for plugins like `cmake-tools.nvim`
- 💡 Minimal setup, pure Lua

## 🚀 Installation

### Using **lazy.nvim**:

```lua
{
  "07CalC/cook.nvim",
  config = function()
    require("cook").setup()
  end,
  cmd = "Cook",
}
```

### Using **packer.nvim**:

```lua
use {
  "07CalC/cook.nvim",
  config = function()
    require("cook").setup()
  end
}
```

## 🔧 Usage

### Default

In any buffer, simply run:

```vim
:Cook
```

It will:

1. Detect the filetype by extension.
2. Build the appropriate shell command.
3. Open a floating terminal and run it.

### Custom recipes

If your project has a `recipes.lua` in its root, you can:

```vim
:Cook dev
:Cook build
```

#### 📦 Project Recipes (recipes.lua)

Define custom tasks at the project root (detected via .git or recipes.lua) using a recipes.lua file:

```lua
--- recipes.lua
return {
  recipes = {
    dev = "cargo watch -x run"
    build = "cargo build --release"
    test = "cargo test"
    fmt = "cargo fmt"
    cmake_build = "!CMakeBuild" -- runs as a Vim command
  }
}
```

📝 Note:

- Commands starting with `!` are executed using `vim.cmd()`, letting you run Vim-native or plugin-provided commands.

### 🧠 CP Mode with `:Coop`

Competitive programming guys, this is for you.
Just copy the input (from a problem description) to clipboard, then run:

```vim
:Coop
```

It will:

1. Detect your filetype.
2. Create a temp file with clipboard contents.
3. Pipe the input to your program (< input.in).
4. Show the output in a terminal buffer.

#### No need to manually paste or prepare files!

## 🛠️ Supported Languages & Commands

You can configure your own runners, but here are the defaults:

```lua
runners = {
  py = "python3 %s",
  c = "gcc %s -o %s && %s",
  cpp = "g++ %s -o %s && %s",
  rs = "cargo run",
  js = "bun %s",
  ts = "bun %s",
  go = "go run %s",
}
```

You can customize this via:

```lua
require("cook").setup({
  runners = {
    py = "python %s",
    sh = "bash %s",
  },
})
```

## 📁 File Structure

```text
lua/
└── cook/
    ├── init.lua       -- Entry point
    ├── config.lua     -- Plugin config and default runners
    ├── filetype.lua   -- Filetype-based runner resolution
    ├── executor.lua   -- Terminal execution
    ├── commands.lua   -- Maps user commands (Cook, Coop)
    └── recipes.lua    -- Project-local task loader
```

## 🙌 Contributing

PRs are welcome! You can:

- Add support for more languages
- Improve command detection
- Add UI options (like vertical split)
