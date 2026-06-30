#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[+]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
section() { echo -e "\n${GREEN}━━━ $1 ━━━${NC}"; }

# ─── Packages ────────────────────────────────────────────────────────────────

section "Installing packages (pacman)"

sudo pacman -S --needed --noconfirm \
    dex \
    xss-lock \
    network-manager-applet \
    bluez bluez-utils blueman \
    xorg-xrandr \
    picom \
    dunst \
    feh \
    polybar \
    rofi \
    pipewire pipewire-pulse wireplumber pavucontrol \
    brightnessctl \
    maim \
    xclip \
    playerctl \
    thunar \
    btop \
    i3lock \
    imagemagick \
    zsh \
    starship \
    zoxide \
    eza \
    bat \
    fzf \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    fastfetch \
    ttf-jetbrains-mono-nerd \
    ttf-font-awesome

# ─── Symlinks ────────────────────────────────────────────────────────────────

section "Linking configs"

link() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        warn "Backup: $dst -> $dst.bak"
        mv "$dst" "$dst.bak"
    fi
    ln -sf "$src" "$dst"
    info "Linked: $dst"
}

link "$DOTFILES/config/dunst"        "$HOME/.config/dunst"
link "$DOTFILES/config/picom"        "$HOME/.config/picom"
link "$DOTFILES/config/polybar"      "$HOME/.config/polybar"
link "$DOTFILES/config/rofi"         "$HOME/.config/rofi"
link "$DOTFILES/config/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES/home/.zshrc"         "$HOME/.zshrc"

# ─── polybar scripts ─────────────────────────────────────────────────────────

chmod +x "$HOME/.config/polybar/launch.sh"
chmod +x "$HOME/.config/polybar/bluetooth.sh"
chmod +x "$HOME/.config/rofi/powermenu.sh"
chmod +x "$HOME/.config/rofi/bluetooth.sh"
chmod +x "$HOME/.config/rofi/wifi.sh"

# ─── Shell ───────────────────────────────────────────────────────────────────

section "Setting zsh as default shell"

if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    info "Default shell set to zsh (re-login to apply)"
else
    info "zsh already default"
fi

# ─── Done ────────────────────────────────────────────────────────────────────

echo ""
info "Done. Re-login or run: exec zsh"
