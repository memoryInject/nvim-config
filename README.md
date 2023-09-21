# nvim-config

A Neovim lua based config.   

Only test with **NVIM v0.9.2 on macOS Ventura 13.2.1**


## Installation

Clone this repo

```bash
git clone https://github.com/memoryInject/nvim-config.git ~/.config/nvim
```

When lauch Neovim for the first time with this config, it will install the plugin manager and all the plugins, LSP, DAP, Linters, Formatters automatically. Ignore any warnings during the first setup (sometimes Treesitter will show some errors and warnings).

### LSP, DAP, Linter, Formatter used in this config

This config come with preconfigured LSP, DAP, Linters and Formatters for:
- JavaScript 
- TypeScrpt 
- Python 
- Lua 
- Bash Script
- C/C++
- Rust (LSP, Linter and Formatter only)
- Chrome debugger for typescript(.ts) and typescriptreact(.tsx)

These are the main languages I use usually.   
Run this command in Neovim to show all the  preconfigured LSP, DAP, Linters and Formatters.
```vimscript
:Mason
```

## Additional requirements
### Requirements for Python  
Install pynvim: `pip3 install pynvim`    
**Note:** `pynvim` is required for [vim-mundo](https://github.com/simnalamburt/vim-mundo/) plugin. 

### Requirements for DAP
This config require custom configuration for DAP debug adapters.     

#### JavaScript/TypeScript vscode-js-debug:   
  - Make sure to install `ts-node` globally for TypeScript debug: `npm i -g ts-node`   
  - Install eslint `npm i -g eslint`

#### C/C++ cpptools setup:  
  - Make sure to install `gcc and gdb`.
  - Example to compile with gcc for debug: `gcc -g -o main main.c`  

### Requirements for Telescope

[Ripgrep for live grep](https://github.com/BurntSushi/ripgrep) 

[Fd for fast file find](https://github.com/sharkdp/fd)

[telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)

### Requirements for WSL
Setup wsl-clipboard for system clipboard support: https://github.com/memoryInject/wsl-clipboard
