# Hyprland Configuration

![Hyprland](https://img.shields.io/badge/Hyprland-blue?style=for-the-badge&logo=hyprland&logoColor=white)
![Wayland](https://img.shields.io/badge/Wayland-black?style=for-the-badge&logo=wayland&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

Konfigurasi Hyprland yang modern, modular, dan mudah dikustomisasi dengan dukungan multi-distro.

## ✨ Fitur

- 🎨 **Modular Configuration** - Konfigurasi terbagi dalam file-file terpisah untuk kemudahan maintenance
- 🖥️ **Multi-Monitor Support** - Dukungan setup multi-monitor dengan nwg-displays
- 🎯 **NVIDIA Ready** - Konfigurasi siap pakai untuk GPU NVIDIA
- 📸 **Screenshot Tools** - Terintegrasi dengan grimblast dan editor gambar
- 📋 **Clipboard Manager** - Menggunakan cliphist untuk manajemen clipboard
- 🎵 **Media Controls** - Kontrol volume, brightness, dan media player
- 🚀 **Auto-installer** - Script instalasi otomatis untuk berbagai distro Linux
- ⚡ **Performance Optimized** - Konfigurasi yang dioptimalkan untuk performa

## 🚀 Instalasi Cepat

### Metode 1: Instalasi Otomatis (Recommended)

```bash
# Clone repository
git clone https://github.com/your-username/hyprland-config.git
cd hyprland-config

# Beri permission execute pada script
chmod +x install.sh

# Jalankan installer
./install.sh
```

### Metode 2: Instalasi Manual

<details>
<summary>Klik untuk melihat langkah instalasi manual</summary>

#### Arch Linux / Manjaro
```bash
# Install package utama
sudo pacman -S hyprland hyprlock hypridle waybar wofi ghostty dolphin \
               wl-clipboard cliphist grim slurp swappy pipewire \
               pipewire-pulse wireplumber polkit-gnome dunst \
               brightnessctl playerctl rofi qt5ct lxappearance \
               pavucontrol blueman network-manager-applet swaybg

# Install AUR packages
yay -S grimblast-git brave-bin nwg-look nwg-displays
```

#### Ubuntu / Debian
```bash
# Update package list
sudo apt update

# Install main packages
sudo apt install hyprland waybar wofi dolphin wl-clipboard grim slurp \
                 swappy pipewire pipewire-pulse wireplumber dunst \
                 brightnessctl playerctl rofi qt5ct lxappearance \
                 pavucontrol blueman network-manager-gnome swaybg
```

#### Fedora
```bash
# Install packages
sudo dnf install hyprland waybar wofi dolphin wl-clipboard grim slurp \
                 swappy pipewire pipewire-pulseaudio wireplumber dunst \
                 brightnessctl playerctl rofi qt5ct lxappearance \
                 pavucontrol blueman NetworkManager-applet swaybg
```

</details>

## 📁 Struktur Konfigurasi

```
~/.config/hypr/
├── hyprland.conf           # Konfigurasi utama
├── hyprlock.conf          # Konfigurasi lock screen
├── monitors.conf          # Setup monitor (auto-generated)
├── workspaces.conf        # Aturan workspace
└── script/
    ├── hyprbind.conf      # Keybindings
    ├── hyprenv.conf       # Environment variables
    ├── hyprinput.conf     # Konfigurasi input
    ├── hyprlook.conf      # Tampilan dan tema
    ├── hyprprogram.conf   # Program default
    ├── hyprstart.conf     # Program autostart
    ├── hyprwindow.conf    # Aturan window
    └── nvidia.conf        # Setting khusus NVIDIA
```

## ⌨️ Keybindings Utama

### Manajemen Window
| Shortcut | Fungsi |
|----------|--------|
| `Super + Return` | Buka terminal |
| `Super + Q` | Tutup window aktif |
| `Super + T` | Toggle floating |
| `Super + F` | Toggle fullscreen |
| `Super + J` | Toggle split |

### Aplikasi
| Shortcut | Fungsi |
|----------|--------|
| `Super + E` | File manager |
| `Super + B` | Browser |
| `Super + L` | Lock screen |
| `Super + R` | App launcher |

### Screenshot
| Shortcut | Fungsi |
|----------|--------|
| `Print` | Screenshot fullscreen (copy) |
| `Super + Print` | Screenshot area (copy) |
| `Ctrl + Print` | Screenshot fullscreen (save) |
| `Super + Ctrl + Print` | Screenshot area (save) |

### Media
| Shortcut | Fungsi |
|----------|--------|
| `XF86AudioRaiseVolume/LowerVolume` | Volume |
| `XF86MonBrightnessUp/Down` | Brightness |
| `XF86AudioPlay/Pause/Next/Prev` | Media control |

### Workspace
| Shortcut | Fungsi |
|----------|--------|
| `Super + 1-9` | Pindah ke workspace |
| `Super + Shift + 1-9` | Pindah window ke workspace |
| `Super + S` | Special workspace (scratchpad) |

## 🔧 Kustomisasi

### Mengubah Program Default
Edit `~/.config/hypr/script/hyprprogram.conf`:
```conf
$terminal = your-terminal
$fileManager = your-file-manager
$menu = your-launcher
$browser = your-browser
```

### Menambah Program Autostart
Edit `~/.config/hypr/script/hyprstart.conf`:
```conf
exec-once = your-program
```

### Konfigurasi Monitor
Gunakan GUI tool:
```bash
nwg-displays
```

Atau edit manual `~/.config/hypr/monitors.conf`:
```conf
monitor=DP-1,1920x1080@144,0x0,1
monitor=HDMI-A-1,1920x1080@60,1920x0,1
```

### Setup NVIDIA
Uncomment pengaturan di `~/.config/hypr/script/nvidia.conf`:
```conf
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia

cursor {
    no_hardware_cursors = true
}
```

## 📦 Dependencies

### Core Dependencies
- `hyprland` - Window manager utama
- `hyprlock` - Screen locker
- `hypridle` - Idle daemon
- `waybar` - Status bar
- `wofi` - Application launcher
- `ghostty` - Terminal emulator
- `dolphin` - File manager
- `pipewire` + `pipewire-pulse` - Audio system

### Screenshot & Media
- `grim` + `slurp` - Screenshot tools
- `grimblast` - Screenshot wrapper
- `swappy` - Screenshot editor
- `cliphist` - Clipboard manager
- `brightnessctl` - Brightness control
- `playerctl` - Media control

### Utilities
- `wl-clipboard` - Clipboard utilities
- `rofi` - Menu system
- `dunst` - Notifications
- `polkit-gnome` - Authentication agent
- `swaybg` - Wallpaper daemon

### Optional
- `brave-bin` - Web browser
- `nwg-displays` - Monitor configuration GUI
- `nwg-look` - GTK theme manager
- `hyprpicker` - Color picker

## 🐛 Troubleshooting

### NVIDIA Issues
- Install `nvidia-vaapi-driver` untuk hardware acceleration
- Jika cursor bermasalah, gunakan `cursor:no_hardware_cursors = true`
- Untuk crash Firefox, comment `env = GBM_BACKEND,nvidia-drm`

### Screenshot Tidak Berfungsi
Pastikan direktori screenshot ada:
```bash
mkdir -p ~/Pictures/Screenshots
```

### Clipboard Tidak Bekerja
Cek apakah cliphist service berjalan:
```bash
pgrep cliphist
```

### Audio Tidak Berfungsi
Restart PipeWire services:
```bash
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Wallpaper Tidak Muncul
Set wallpaper di `~/Pictures/wallpaper.jpg` atau edit autostart:
```conf
exec-once = swaybg -i /path/to/your/wallpaper.jpg -m fill
```

## 🔄 Update Configuration

Untuk update konfigurasi:
```bash
cd hyprland-config
git pull
./install.sh
```

## 📝 Tips & Tricks

### 1. Backup Konfigurasi
```bash
cp -r ~/.config/hypr ~/.config/hypr.backup
```

### 2. Reload Konfigurasi
```bash
hyprctl reload
```

### 3. Debug Mode
```bash
hyprctl monitors    # Lihat monitor tersedia
hyprctl clients     # Lihat window yang berjalan
hyprctl workspaces  # Lihat workspace
```

### 4. Custom Workspace Rules
Edit `~/.config/hypr/script/hyprwindow.conf`:
```conf
windowrulev2 = workspace 2,class:(firefox)
windowrulev2 = workspace 3,class:(code)
```

## 🤝 Contributing

1. Fork repository ini
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 License

Project ini menggunakan MIT License - lihat file [LICENSE](LICENSE) untuk detail.

## 🙏 Acknowledgments

- [Hyprland](https://hyprland.org/) - Amazing Wayland compositor
- [Waybar](https://github.com/Alexays/Waybar) - Customizable status bar
- [Grimblast](https://github.com/hyprwm/contrib) - Screenshot utility
- Community Hyprland untuk inspirasi konfigurasi

## 📞 Support

Jika ada pertanyaan atau masalah:
- Buka issue di GitHub
- Join Discord Hyprland community
- Cek [Hyprland Wiki](https://wiki.hyprland.org/)

---

⭐ **Jangan lupa star repository ini jika helpful!** ⭐