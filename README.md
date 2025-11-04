
# .dotfiles installation

## zsh

```
sudo apt install fzf ripgrep

git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.zsh/fast-syntax-highlighting

# compile faster colorizing output
sudo apt install build-essential autoconf libncurses-dev
cd ~/.zsh/fzf-tab
build-fzf-tab-module 


# For prompt customization
curl -sS https://starship.rs/install.sh | sh

```
