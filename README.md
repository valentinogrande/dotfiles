# dotfiles — Minimalista Oscuro

Setup de escritorio i3 para Arch Linux.

## Contenido

| Config | Descripción |
|---|---|
| `i3` | WM X11, gaps, 2 monitores, keybindings |
| `hypr` | WM Wayland (Hyprland): hyprland, hyprpaper, hyprlock, hypridle |
| `waybar` | Barra Wayland (equivalente a polybar) |
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
xrandr --query   # ver nombres reales (X11 / i3)
```

### Hyprland (Wayland)

```bash
# Verificar nombres de monitor y ajustar $left/$right en ~/.config/hypr/hyprland.conf:
hyprctl monitors   # ej: DP-1, HDMI-A-1 (difieren de xrandr)
```

Iniciar desde TTY con `Hyprland`, o agregar al display manager.
Reutiliza `rofi` (vía XWayland) y `dunst`; la barra es `waybar` en vez de polybar.

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
    ├── hypr/
    │   ├── hyprland.conf
    │   ├── hyprpaper.conf
    │   ├── hyprlock.conf
    │   └── hypridle.conf
    ├── waybar/
    │   ├── config.jsonc
    │   └── style.css
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
