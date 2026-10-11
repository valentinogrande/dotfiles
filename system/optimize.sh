#!/usr/bin/env bash
# Ajustes del sistema que necesitan root. Correr con: sudo bash ~/dotfiles/system/optimize.sh
# Es seguro correrlo más de una vez.
set -euo pipefail
D="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
step() { echo -e "\033[0;32m[+]\033[0m $1"; }

step "Wifi: apagar iwd (NetworkManager usa wpa_supplicant; los dos peleaban por la placa y el arranque esperaba ~1 min)"
systemctl disable --now iwd 2>/dev/null || true

step "Swap en zram del tamaño de la RAM + sysctl para zram (el tamaño aplica al reiniciar)"
install -Dm644 "$D/zram-generator.conf" /etc/systemd/zram-generator.conf
install -Dm644 "$D/99-zram.sysctl.conf" /etc/sysctl.d/99-zram.conf
sysctl --system >/dev/null

step "Logs del sistema: máximo 300 MB"
install -Dm644 "$D/journald-size.conf" /etc/systemd/journald.conf.d/size.conf
systemctl restart systemd-journald
journalctl --vacuum-size=300M >/dev/null

step "Caché de pacman: dejar solo la última versión de cada paquete y limpiarla cada semana"
pacman -S --needed --noconfirm pacman-contrib >/dev/null
paccache -rqk1
paccache -rquk0
systemctl enable --now paccache.timer

step "Docker: rotar logs de contenedores (20 MB x 3) y live-restore (aplica al próximo reinicio de Docker)"
if [[ ! -e /etc/docker/daemon.json ]]; then
  install -Dm644 "$D/docker-daemon.json" /etc/docker/daemon.json
else
  echo "    /etc/docker/daemon.json ya existe, no lo toco"
fi

step "Listo. Reiniciá para aplicar la swap nueva."
