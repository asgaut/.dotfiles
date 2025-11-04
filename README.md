
# .dotfiles installation

## zsh

```
sudo apt install fzf

mkdir -p .config/zsh
git clone https://github.com/Aloxaf/fzf-tab ~/.config/zsh/fzf-tab
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.config/zsh/fast-syntax-highlighting

sudo apt install build-essential autoconf libncurses-dev
build-fzf-tab-module 

sudo apt install ripgrep
```

