#!/bin/bash

# Quick Setup Script for Hyprland Configuration
# Lightweight version of the main installer

set -e

print_info() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

print_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

# Quick setup function
quick_setup() {
    print_info "Starting Hyprland quick setup..."
    
    # Create directories
    HYPR_DIR="$HOME/.config/hypr"
    mkdir -p "$HYPR_DIR/script"
    mkdir -p "$HOME/Pictures/Screenshots"
    
    # Backup existing config
    if [[ -f "$HYPR_DIR/hyprland.conf" ]]; then
        print_warning "Backing up existing configuration..."
        mv "$HYPR_DIR/hyprland.conf" "$HYPR_DIR/hyprland.conf.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Copy all configuration files
    if [[ -f "hyprland.conf" ]]; then
        print_info "Copying configuration files..."
        cp *.conf "$HYPR_DIR/" 2>/dev/null || true
        cp script/*.conf "$HYPR_DIR/script/" 2>/dev/null || true
        cp .gitignore "$HYPR_DIR/" 2>/dev/null || true
        print_success "Configuration files copied!"
    else
        print_error "Configuration files not found in current directory!"
        exit 1
    fi
    
    # Create basic monitor config if doesn't exist
    if [[ ! -f "$HYPR_DIR/monitors.conf" ]]; then
        echo "monitor=,preferred,auto,1" > "$HYPR_DIR/monitors.conf"
        print_info "Created basic monitor configuration"
    fi
    
    print_success "Quick setup completed!"
    print_info "Please install required packages manually and restart Hyprland"
    print_info "For full installation, use: ./install.sh"
}

# Check if in correct directory
if [[ ! -f "hyprland.conf" ]]; then
    print_error "Please run this script from the hyprland-config directory"
    exit 1
fi

quick_setup