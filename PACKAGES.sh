#!/bin/bash

# Package requirements for different distributions
# This file lists all required packages for manual installation

echo "=== HYPRLAND CONFIGURATION PACKAGE REQUIREMENTS ==="
echo

echo "ARCH LINUX / MANJARO:"
echo "sudo pacman -S hyprland hyprlock hypridle waybar wofi ghostty dolphin \\"
echo "               wl-clipboard cliphist grim slurp swappy pipewire \\"
echo "               pipewire-pulse wireplumber polkit-gnome dunst \\"
echo "               brightnessctl playerctl rofi qt5ct lxappearance \\"
echo "               pavucontrol blueman network-manager-applet swaybg"
echo
echo "yay -S grimblast-git brave-bin nwg-look nwg-displays hyprpicker hyprcursor"
echo

echo "UBUNTU / DEBIAN:"
echo "sudo apt install hyprland waybar wofi dolphin wl-clipboard grim slurp \\"
echo "                 swappy pipewire pipewire-pulse wireplumber dunst \\"
echo "                 brightnessctl playerctl rofi qt5ct lxappearance \\"
echo "                 pavucontrol blueman network-manager-gnome swaybg"
echo

echo "FEDORA:"
echo "sudo dnf install hyprland waybar wofi dolphin wl-clipboard grim slurp \\"
echo "                 swappy pipewire pipewire-pulseaudio wireplumber dunst \\"
echo "                 brightnessctl playerctl rofi qt5ct lxappearance \\"
echo "                 pavucontrol blueman NetworkManager-applet swaybg"
echo

echo "OPENSUSE:"
echo "sudo zypper install hyprland waybar wofi dolphin wl-clipboard grim slurp \\"
echo "                    swappy pipewire pipewire-pulseaudio wireplumber dunst \\"
echo "                    brightnessctl playerctl rofi qt5ct lxappearance \\"
echo "                    pavucontrol blueman NetworkManager-applet swaybg"
echo

echo "=== CORE COMPONENTS ==="
echo "• hyprland          - Main window manager"
echo "• hyprlock          - Screen locker"
echo "• hypridle          - Idle daemon"
echo "• waybar            - Status bar"
echo "• wofi              - Application launcher"
echo "• ghostty           - Terminal emulator"
echo "• dolphin           - File manager"
echo "• pipewire          - Audio system"
echo

echo "=== UTILITIES ==="
echo "• grim + slurp      - Screenshot tools"
echo "• grimblast         - Screenshot wrapper (AUR)"
echo "• swappy            - Screenshot editor"
echo "• cliphist          - Clipboard manager"
echo "• wl-clipboard      - Clipboard utilities"
echo "• brightnessctl     - Brightness control"
echo "• playerctl         - Media control"
echo "• rofi              - Menu system"
echo "• dunst             - Notifications"
echo "• polkit-gnome      - Authentication agent"
echo "• swaybg            - Wallpaper daemon"
echo

echo "=== OPTIONAL ==="
echo "• brave-bin         - Web browser (AUR)"
echo "• nwg-displays      - Monitor configuration GUI"
echo "• nwg-look          - GTK theme manager"
echo "• hyprpicker        - Color picker"
echo "• hyprcursor        - Cursor theme manager"
echo

echo "=== POST-INSTALL ==="
echo "1. Enable PipeWire: systemctl --user enable --now pipewire pipewire-pulse wireplumber"
echo "2. Copy config: ./quick-setup.sh or ./install.sh"
echo "3. Set wallpaper in ~/Pictures/wallpaper.jpg"
echo "4. Configure monitors with nwg-displays"
echo "5. For NVIDIA: uncomment settings in script/nvidia.conf"