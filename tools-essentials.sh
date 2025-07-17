#!/bin/bash

set -e

USERNAME="lg"

# Ensure sudo available
if ! sudo -v; then
  echo "Sudo authentication failed."
  exit 1
fi

echo "➤ Adding '$USERNAME' to sudo group..."
sudo usermod -aG sudo "$USERNAME"

echo "➤ Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

echo "➤ Installing packages..."
sudo apt install -y \
    git \
    curl \
    zsh \
    wget \
    htop \
    vim \
    unzip \
    gnupg \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    sudo \
    keepassxc

echo "➤ Installing Google Chrome..."
wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y /tmp/google-chrome.deb
rm /tmp/google-chrome.deb

echo "➤ Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
sudo install -o root -g root -m 644 /tmp/microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code
rm /tmp/microsoft.gpg

echo "➤ Installing MesloLGS Nerd Font (for Powerlevel10k)..."
FONT_DIR="/usr/share/fonts/truetype/meslo-nerd-font"
sudo mkdir -p "$FONT_DIR"
sudo wget -qO "$FONT_DIR/MesloLGS NF Regular.ttf"    https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
sudo wget -qO "$FONT_DIR/MesloLGS NF Bold.ttf"       https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
sudo wget -qO "$FONT_DIR/MesloLGS NF Italic.ttf"     https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
sudo wget -qO "$FONT_DIR/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
sudo fc-cache -f -v

echo
echo " Setup complete!"

cat <<'EOF'

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set Powerlevel10k as theme
sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc

# Restart shell
exec zsh
EOF
