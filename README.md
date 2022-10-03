# nvim-config

A Neovim lua based config. **Important:** This is still an early conversion from my vimscript
to lua based config, there may be some breaking changes with some of the plugin used in this 
config. 

Only test with NVIM v0.8.0


## Installation

Clone this repo

```bash
git clone https://github.com/memoryInject/nvim-config.git ~/.config/nvim
```

When lauch first time Neovim after this config it will install the plugin manager and 
all the plugins automatically.

### LSP used in my setup
```vimscript
:LspInstallInfo

html
jsonls
pyright
sumneko_lua
tsserver
```

## Additional requirements

### Requirements for null-ls
This config require to install `prettier` and `eslint` globally for null-ls diagonstics and formatting
```bash
npm i -g prettier eslint
```

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

### Requirements for WSL
Setup wsl-clipboard for system clipboard support: https://github.com/memoryInject/wsl-clipboard
