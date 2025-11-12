# Raspberry Pi Kiosk (Chromium) — JC Vision Play

Este guia configura um Raspberry Pi para abrir o Chromium em modo kiosk na URL do Player e manter o processo monitorado.

## Dispositivo
- Hostname: `CS-RSP-TERIVA`
- URL do Player: `https://jc-vision-play.vercel.app/player/c5dc8d9fef4bdf859b1a887e566f5c89`

## Pacotes necessários
```bash
sudo apt update
sudo apt install -y chromium-browser xserver-xorg x11-xserver-utils unclutter
```

## Definir hostname
```bash
sudo hostnamectl set-hostname CS-RSP-TERIVA
```

## Opção A — systemd (robusto e monitorado)
1. Copie `raspi/kiosk.service` para o Pi:
```bash
sudo cp /caminho/para/raspi/kiosk.service /etc/systemd/system/kiosk.service
sudo systemctl daemon-reload
sudo systemctl enable kiosk
sudo systemctl start kiosk
```
2. O serviço iniciará o Chromium em modo kiosk com recuperação automática.

## Opção B — LXDE Autostart (simples)
1. Edite o autostart:
```bash
sudo nano /etc/xdg/lxsession/LXDE-pi/autostart
```
2. Cole o conteúdo de `raspi/lxde-autostart`.
3. Reinicie: `sudo reboot`

## Rotação e resolução (opcional)
```bash
# Rotacionar para vertical
xrandr -o left

# Forçar 1080p60 (exemplo)
xrandr --output HDMI-1 --mode 1920x1080 --rate 60
```

## Flags de performance para YouTube
- `--autoplay-policy=no-user-gesture-required`
- `--enable-accelerated-video-decode`
- `--use-gl=egl`

## Troubleshooting
- Tela apagando: use `xset s off`, `xset -dpms`, `xset s noblank` (já incluído).
- Cursor visível: `unclutter` oculta o cursor.
- Se cair, `systemd` reinicia o Chromium automaticamente.