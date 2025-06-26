#!/bin/bash

# Hyprland Configuration Auto Installer
# Script untuk instalasi otomatis konfigurasi Hyprland modular

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}================================${NC}"
}

# Function to detect package manager
detect_package_manager() {
    if command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v apt &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v zypper &> /dev/null; then
        echo "zypper"
    else
        echo "unknown"
    fi
}

# Function to check if AUR helper is available
check_aur_helper() {
    if command -v yay &> /dev/null; then
        echo "yay"
    elif command -v paru &> /dev/null; then
        echo "paru"
    else
        echo "none"
    fi
}

# Function to install AUR helper if needed (Arch only)
install_aur_helper() {
    local aur_helper=$(check_aur_helper)
    
    if [[ $aur_helper == "none" ]] && [[ $(detect_package_manager) == "pacman" ]]; then
        print_status "Installing yay AUR helper..."
        
        # Install base-devel and git if not present
        sudo pacman -S --needed --noconfirm base-devel git
        
        # Clone and install yay
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
        
        print_success "yay AUR helper installed successfully!"
    fi
}

# Function to install packages based on package manager
install_packages() {
    local pm=$1
    shift
    local packages=("$@")
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        return
    fi
    
    case $pm in
        "pacman")
            print_status "Installing packages with pacman: ${packages[*]}"
            sudo pacman -S --needed --noconfirm "${packages[@]}" 2>/dev/null || true
            ;;
        "apt")
            print_status "Installing packages with apt: ${packages[*]}"
            sudo apt update -qq
            sudo apt install -y "${packages[@]}" 2>/dev/null || true
            ;;
        "dnf")
            print_status "Installing packages with dnf: ${packages[*]}"
            sudo dnf install -y "${packages[@]}" 2>/dev/null || true
            ;;
        "zypper")
            print_status "Installing packages with zypper: ${packages[*]}"
            sudo zypper install -y "${packages[@]}" 2>/dev/null || true
            ;;
        *)
            print_error "Unsupported package manager. Please install packages manually: ${packages[*]}"
            ;;
    esac
}

# Function to install AUR packages (Arch only)
install_aur_packages() {
    local aur_helper=$(check_aur_helper)
    local packages=("$@")
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        return
    fi
    
    if [[ $aur_helper != "none" ]]; then
        print_status "Installing AUR packages with $aur_helper: ${packages[*]}"
        $aur_helper -S --needed --noconfirm "${packages[@]}" 2>/dev/null || true
    else
        print_warning "No AUR helper found. Please install AUR packages manually: ${packages[*]}"
    fi
}

# Function to create default configuration files
create_default_configs() {
    local hypr_dir="$1"
    local script_dir="$hypr_dir/script"
    
    # Create monitors.conf
    if [[ ! -f "$hypr_dir/monitors.conf" ]]; then
        cat > "$hypr_dir/monitors.conf" << 'EOF'
# Monitor configuration
# Use 'hyprctl monitors' to see available monitors
# Format: monitor=name,resolution@refreshrate,position,scale

monitor=,preferred,auto,1
EOF
    fi
    
    # Create hyprprogram.conf
    if [[ ! -f "$script_dir/hyprprogram.conf" ]]; then
        cat > "$script_dir/hyprprogram.conf" << 'EOF'
# Default programs
$terminal = ghostty
$fileManager = dolphin
$menu = wofi --show drun
$browser = brave
$editor = code
EOF
    fi
    
    # Create hyprstart.conf
    if [[ ! -f "$script_dir/hyprstart.conf" ]]; then
        cat > "$script_dir/hyprstart.conf" << 'EOF'
# Autostart programs
exec-once = waybar
exec-once = wl-paste --watch cliphist store
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = hypridle

# Background and wallpaper
exec-once = swaybg -i ~/Pictures/wallpaper.jpg -m fill

# Notifications
exec-once = dunst
EOF
    fi
    
    # Create hyprenv.conf
    if [[ ! -f "$script_dir/hyprenv.conf" ]]; then
        cat > "$script_dir/hyprenv.conf" << 'EOF'
# Environment variables
env = XCURSOR_SIZE,24
env = HYPRCURSOR_SIZE,24
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,qt5ct
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
env = MOZ_ENABLE_WAYLAND,1
env = GDK_BACKEND,wayland,x11
EOF
    fi
    
    # Create hyprlook.conf
    if [[ ! -f "$script_dir/hyprlook.conf" ]]; then
        cat > "$script_dir/hyprlook.conf" << 'EOF'
# Look and feel
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    resize_on_border = false
    allow_tearing = false
    layout = dwindle
}

decoration {
    rounding = 10
    active_opacity = 1.0
    inactive_opacity = 1.0
    
    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
    
    blur {
        enabled = true
        size = 3
        passes = 1
        vibrancy = 0.1696
    }
}

animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    pseudotile = true
    preserve_split = true
}

master {
    new_is_master = true
}

misc {
    force_default_wallpaper = -1
    disable_hyprland_logo = false
}
EOF
    fi
    
    # Create hyprinput.conf
    if [[ ! -f "$script_dir/hyprinput.conf" ]]; then
        cat > "$script_dir/hyprinput.conf" << 'EOF'
# Input configuration
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =
    
    follow_mouse = 1
    sensitivity = 0
    
    touchpad {
        natural_scroll = false
    }
}

gestures {
    workspace_swipe = false
}

device {
    name = epic-mouse-v1
    sensitivity = -0.5
}
EOF
    fi
    
    # Create hyprbind.conf
    if [[ ! -f "$script_dir/hyprbind.conf" ]]; then
        cat > "$script_dir/hyprbind.conf" << 'EOF'
# Keybindings
$mainMod = SUPER

# Applications
bind = $mainMod, Return, exec, $terminal
bind = $mainMod, Q, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, $fileManager
bind = $mainMod, V, togglefloating,
bind = $mainMod, R, exec, $menu
bind = $mainMod, P, pseudo,
bind = $mainMod, J, togglesplit,
bind = $mainMod, F, fullscreen
bind = $mainMod, L, exec, hyprlock
bind = $mainMod, B, exec, $browser

# Screenshots
bind = , Print, exec, grimblast copy output
bind = $mainMod, Print, exec, grimblast copy area
bind = CTRL, Print, exec, grimblast save output ~/Pictures/Screenshots/
bind = $mainMod CTRL, Print, exec, grimblast save area ~/Pictures/Screenshots/

# Clipboard
bind = $mainMod, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy

# Media keys
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind = , XF86AudioPlay, exec, playerctl play-pause
bind = , XF86AudioPause, exec, playerctl play-pause
bind = , XF86AudioNext, exec, playerctl next
bind = , XF86AudioPrev, exec, playerctl previous

# Brightness
bind = , XF86MonBrightnessUp, exec, brightnessctl set 10%+
bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-

# Move focus
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move windows to workspace
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Special workspace (scratchpad)
bind = $mainMod, S, togglespecialworkspace, magic
bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# Scroll through workspaces
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow
EOF
    fi
    
    # Create hyprwindow.conf
    if [[ ! -f "$script_dir/hyprwindow.conf" ]]; then
        cat > "$script_dir/hyprwindow.conf" << 'EOF'
# Window rules
windowrulev2 = float,class:(pavucontrol)
windowrulev2 = float,class:(blueman-manager)
windowrulev2 = float,class:(nm-connection-editor)
windowrulev2 = float,class:(lxappearance)
windowrulev2 = float,class:(qt5ct)
windowrulev2 = float,class:(nwg-look)

# Browser picture-in-picture
windowrulev2 = float,title:(Picture-in-Picture)
windowrulev2 = pin,title:(Picture-in-Picture)
windowrulev2 = size 400 225,title:(Picture-in-Picture)

# File dialogs
windowrulev2 = float,class:(xdg-desktop-portal-gtk)
EOF
    fi
    
    # Create nvidia.conf
    if [[ ! -f "$script_dir/nvidia.conf" ]]; then
        cat > "$script_dir/nvidia.conf" << 'EOF'
# NVIDIA-specific settings
# Uncomment if you have NVIDIA GPU

# env = LIBVA_DRIVER_NAME,nvidia
# env = XDG_SESSION_TYPE,wayland
# env = GBM_BACKEND,nvidia-drm
# env = __GLX_VENDOR_LIBRARY_NAME,nvidia

# cursor {
#     no_hardware_cursors = true
# }
EOF
    fi
}

# Main installation function
main() {
    print_header "HYPRLAND CONFIGURATION INSTALLER"
    print_status "Starting Hyprland configuration installation..."
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root!"
        exit 1
    fi
    
    # Detect package manager
    PM=$(detect_package_manager)
    print_status "Detected package manager: $PM"
    
    if [[ $PM == "unknown" ]]; then
        print_error "Unsupported package manager. This script supports pacman, apt, dnf, and zypper."
        exit 1
    fi
    
    # Install AUR helper for Arch
    if [[ $PM == "pacman" ]]; then
        install_aur_helper
    fi
    
    print_header "INSTALLING PACKAGES"
    
    # Define packages based on package manager
    case $PM in
        "pacman")
            CORE_PACKAGES=(
                "hyprland"
                "hyprlock"
                "hypridle"
                "waybar"
                "wofi"
                "ghostty"
                "dolphin"
                "wl-clipboard"
                "cliphist"
                "grim"
                "slurp"
                "swappy"
                "pipewire"
                "pipewire-pulse"
                "wireplumber"
                "polkit-gnome"
                "dunst"
                "brightnessctl"
                "playerctl"
                "rofi"
                "qt5ct"
                "lxappearance"
                "pavucontrol"
                "blueman"
                "network-manager-applet"
                "swaybg"
            )
            
            OPTIONAL_PACKAGES=(
                "nwg-look"
                "nwg-displays"
                "hyprpicker"
                "hyprcursor"
            )
            
            AUR_PACKAGES=(
                "grimblast-git"
                "brave-bin"
            )
            ;;
        "apt")
            CORE_PACKAGES=(
                "hyprland"
                "waybar"
                "wofi"
                "dolphin"
                "wl-clipboard"
                "grim"
                "slurp"
                "swappy"
                "pipewire"
                "pipewire-pulse"
                "wireplumber"
                "dunst"
                "brightnessctl"
                "playerctl"
                "rofi"
                "qt5ct"
                "lxappearance"
                "pavucontrol"
                "blueman"
                "network-manager-gnome"
                "swaybg"
            )
            
            OPTIONAL_PACKAGES=(
                "brave-browser"
            )
            ;;
        "dnf")
            CORE_PACKAGES=(
                "hyprland"
                "waybar"
                "wofi"
                "dolphin"
                "wl-clipboard"
                "grim"
                "slurp"
                "swappy"
                "pipewire"
                "pipewire-pulseaudio"
                "wireplumber"
                "dunst"
                "brightnessctl"
                "playerctl"
                "rofi"
                "qt5ct"
                "lxappearance"
                "pavucontrol"
                "blueman"
                "NetworkManager-applet"
                "swaybg"
            )
            
            OPTIONAL_PACKAGES=(
                "brave-browser"
            )
            ;;
        "zypper")
            CORE_PACKAGES=(
                "hyprland"
                "waybar"
                "wofi"
                "dolphin"
                "wl-clipboard"
                "grim"
                "slurp"
                "swappy"
                "pipewire"
                "pipewire-pulseaudio"
                "wireplumber"
                "dunst"
                "brightnessctl"
                "playerctl"
                "rofi"
                "qt5ct"
                "lxappearance"
                "pavucontrol"
                "blueman"
                "NetworkManager-applet"
                "swaybg"
            )
            
            OPTIONAL_PACKAGES=()
            ;;
    esac
    
    # Install core packages
    print_status "Installing core packages..."
    install_packages "$PM" "${CORE_PACKAGES[@]}"
    
    # Install optional packages
    if [[ ${#OPTIONAL_PACKAGES[@]} -gt 0 ]]; then
        print_status "Installing optional packages..."
        install_packages "$PM" "${OPTIONAL_PACKAGES[@]}"
    fi
    
    # Install AUR packages for Arch
    if [[ $PM == "pacman" ]] && [[ ${#AUR_PACKAGES[@]} -gt 0 ]]; then
        print_status "Installing AUR packages..."
        install_aur_packages "${AUR_PACKAGES[@]}"
    fi
    
    print_header "SETTING UP CONFIGURATION"
    
    # Create hypr config directory
    HYPR_DIR="$HOME/.config/hypr"
    SCRIPT_DIR="$HYPR_DIR/script"
    
    print_status "Creating Hyprland configuration directories..."
    mkdir -p "$SCRIPT_DIR"
    mkdir -p "$HOME/Pictures/Screenshots"
    mkdir -p "$HOME/Pictures"
    
    # Backup existing config if it exists
    if [[ -f "$HYPR_DIR/hyprland.conf" ]]; then
        BACKUP_NAME="hyprland.conf.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Existing Hyprland config found. Creating backup: $BACKUP_NAME"
        mv "$HYPR_DIR/hyprland.conf" "$HYPR_DIR/$BACKUP_NAME"
    fi
    
    # Copy configuration files if they exist in current directory
    print_status "Setting up configuration files..."
    
    if [[ -f "hyprland.conf" ]]; then
        print_status "Copying existing configuration files..."
        cp hyprland.conf "$HYPR_DIR/" 2>/dev/null || true
        cp hyprlock.conf "$HYPR_DIR/" 2>/dev/null || true
        cp workspaces.conf "$HYPR_DIR/" 2>/dev/null || true
        cp script/* "$SCRIPT_DIR/" 2>/dev/null || true
        cp .gitignore "$HYPR_DIR/" 2>/dev/null || true
        print_success "Configuration files copied!"
    else
        print_status "Creating default configuration files..."
        create_default_configs "$HYPR_DIR"
        print_success "Default configuration files created!"
    fi
    
    # Generate or create monitors.conf
    if command -v nwg-displays &> /dev/null; then
        print_status "Generating monitor configuration with nwg-displays..."
        nwg-displays -o "$HYPR_DIR/monitors.conf" 2>/dev/null || true
    elif [[ ! -f "$HYPR_DIR/monitors.conf" ]]; then
        print_status "Creating basic monitor configuration..."
        echo "monitor=,preferred,auto,1" > "$HYPR_DIR/monitors.conf"
    fi
    
    print_header "ENABLING SERVICES"
    
    # Enable and start PipeWire services
    if command -v systemctl &> /dev/null; then
        print_status "Enabling PipeWire services..."
        systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true
        print_success "PipeWire services enabled!"
    fi
    
    # Create desktop entry for Hyprland if it doesn't exist
    DESKTOP_FILE="/usr/share/wayland-sessions/hyprland.desktop"
    if [[ ! -f "$DESKTOP_FILE" ]] && command -v hyprland &> /dev/null; then
        print_status "Creating Hyprland desktop entry..."
        sudo mkdir -p /usr/share/wayland-sessions
        sudo tee "$DESKTOP_FILE" > /dev/null << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF
        print_success "Hyprland desktop entry created!"
    fi
    
    # Set up wallpaper directory
    if [[ ! -f "$HOME/Pictures/wallpaper.jpg" ]]; then
        print_status "Setting up default wallpaper..."
        # Create a simple gradient wallpaper if no wallpaper exists
        if command -v convert &> /dev/null; then
            convert -size 1920x1080 gradient:#1a1a2e-#16213e "$HOME/Pictures/wallpaper.jpg" 2>/dev/null || true
        fi
    fi
    
    print_header "INSTALLATION COMPLETE"
    print_success "Hyprland configuration installation completed successfully!"
    
    echo
    print_status "Next steps:"
    echo "1. Log out of your current session"
    echo "2. Select Hyprland from your display manager"
    echo "3. Adjust monitor configuration: ~/.config/hypr/monitors.conf"
    echo "4. Customize keybindings: ~/.config/hypr/script/hyprbind.conf"
    echo "5. Set your wallpaper in ~/Pictures/wallpaper.jpg"
    echo "6. For NVIDIA users: uncomment NVIDIA settings in ~/.config/hypr/script/nvidia.conf"
    
    echo
    print_status "Configuration files location:"
    echo "  Main config: ~/.config/hypr/hyprland.conf"
    echo "  Scripts: ~/.config/hypr/script/"
    echo "  Screenshots: ~/Pictures/Screenshots/"
    
    echo
    print_status "Useful commands:"
    echo "  hyprctl monitors - List available monitors"
    echo "  hyprctl clients - List running windows"
    echo "  hyprctl reload - Reload configuration"
    
    print_success "Enjoy your new Hyprland setup!"
}

# Show help
show_help() {
    echo "Hyprland Configuration Auto Installer"
    echo
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --version  Show version information"
    echo
    echo "This script will:"
    echo "  - Detect your package manager"
    echo "  - Install required packages for Hyprland"
    echo "  - Set up configuration files"
    echo "  - Enable necessary services"
    echo
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        echo "Hyprland Configuration Installer v1.0"
        exit 0
        ;;
    "")
        main "$@"
        ;;
    *)
        print_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac