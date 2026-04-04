# dotfiles — Minimalista Oscuro

Setup de escritorio i3 para Arch Linux.

## Contenido

| Config | Descripción |
|---|---|
| `i3` | WM, gaps, 2 monitores, keybindings |
| `kitty` | Terminal, transparencia, powerline tabs |
| `polybar` | Barra de estado con audio, batería, wifi, media |
| `picom` | Compositor: blur, sombras, transparencia |
| `dunst` | Notificaciones estilo dark |
| `rofi` | Lanzador de apps + power menu |
| `starship` | Prompt gruvbox con git, tiempo, lenguajes |
| `.zshrc` | Zsh con eza, bat, fzf, zoxide, starship, aliases git |

## Instalación

```bash
git clone https://github.com/valentinogrande/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

El script:
1. Instala todos los paquetes con `pacman`
2. Crea symlinks de cada config a `~/.config/`
3. Instala `lockscreen` en `~/.local/bin/`
4. Configura `zsh` como shell por defecto

## Post-instalación

```bash
# Poner wallpaper en:
mkdir -p ~/Pictures/wallpapers
cp ~/dotfiles/config/i3/wallpaper.png ~/Pictures/wallpapers/aurora-iceland.jpg

# Ajustar outputs de monitor en ~/.config/i3/config si cambian los nombres:
xrandr --query   # ver nombres reales
```

## Estructura

```
dotfiles/
├── install.sh
├── home/
│   └── .zshrc
└── config/
    ├── i3/
    │   ├── config
    │   ├── lockscreen       # script: screenshot + blur + i3lock
    │   └── wallpaper.png
    ├── kitty/
    │   └── kitty.conf
    ├── polybar/
    │   ├── config.ini
    │   └── launch.sh
    ├── picom/
    │   └── picom.conf
    ├── dunst/
    │   └── dunstrc
    ├── rofi/
    │   ├── dark.rasi
    │   └── powermenu.sh
    └── starship.toml
```
