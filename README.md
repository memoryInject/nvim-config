# nvim-config

A Neovim lua based config.   

**Important:** This is still an early conversion from my vimscript to lua based config, there may be some breaking changes with some of the plugin used in this config. 

Only test with **NVIM v0.9.0-dev** on Linux Ubuntu 20.04.5 LTS and WSL Ubuntu 20.04.2 LTS on Windows 10 x86_64.


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

These are the main languages I use usually.   
Run this command in Neovim to show all the  preconfigured LSP, DAP, Linters and Formatters.
```vimscript
:Mason
```

**Optional:**  add mason bin path to ~/.zshrc to access all the LSP, DAP, Linters and Formatters outside Neovim
```bash
echo 'export PATH="/home/$USER/.local/share/nvim/mason/bin:$PATH"' >> ~/.zshrc
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

Ripgrep for live grep:
```bash
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb
```

Fd for fast file find:
```bash
wget https://github.com/sharkdp/fd/releases/download/v8.4.0/fd_8.4.0_amd64.deb
sudo dpkg -i fd_8.4.0_amd64.deb
```

[telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim):    
more info: https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation
```bash
sudo apt-get install cmake make gcc clang
```

### Requirements for WSL
Setup wsl-clipboard for system clipboard support: https://github.com/memoryInject/wsl-clipboard
