# 🍳 cook.nvim

**cook.nvim** is a modular and extensible Neovim plugin that lets you effortlessly compile or run the current file based on its filetype — inside a floating terminal.

![cook nvim demo](https://github.com/user-attachments/assets/e2c8220c-5fea-4b3f-8d14-b136900bbe82)

Supports:
- 🐍 Python
- 🦀 Rust
- 🧠 C/C++
- 🌀 JavaScript / TypeScript
- 🦫 Go

---

## ✨ Features

- 📂 Runs code from the current buffer based on its extension
- 🪟 Opens a floating terminal inside Neovim
- ⚙️ Easily extendable for any language
- 💡 Minimal setup, pure Lua

---

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

### Using **Packer.nvim**:

```lua
use {
  "07CalC/cook.nvim",
  config = function()
      require("cook").setup()
  end
}
```

---

## 🔧 Usage
In any buffer, simply run:
```vim
:Cook
```
It will:
1. Detect the filetype by extension.
2. Build the appropriate shell command.
3. Open a floating terminal and run it.

---

## 🛠️ Supported Languages & Commands
You can configure your own runners, but here are the defaults:
```lua
runners = {
		py = "python3 %s",
		c = "gcc %s -o %s && .%s",
		cpp = "g++ %s -o %s && .%s",
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

---

## 📁 File Structure
```text
lua/
└── cook/
    ├── init.lua       -- Entry point
    ├── config.lua     -- Plugin config and default runners
    ├── filetype.lua   -- Filetype-based runner resolution
    └── executor.lua   -- Floating terminal executor
```

---

## 🙌 Contributing
PRs are welcome! You can:

  - Add support for more languages

  - Improve command detection

  -  Add UI options (like vertical split)
