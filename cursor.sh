#!/bin/bash

set -e

echo "📥 Downloading Cursor AppImage and icon..."

# Cursor AppImage URL (example version 1.2.2)
ICON_URL="https://img.icons8.com/?size=512&id=DiGZkjCzyZXn&format=png"

# Create required directories
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/icons
mkdir -p ~/.local/share/applications


# Install Cursor AppImage from local file
cp /home/lg/Downloads/Cursor-1.2.2-x86_64.AppImage ~/.local/bin/Cursor
chmod +x ~/.local/bin/Cursor

# Download icon and rename it
curl -L -o ~/.local/share/icons/cursor-icon.png "$ICON_URL"

echo "🔧 Setting up Cursor launcher scripts and desktop entry..."

# Create CLI wrapper
cat << 'EOF' > ~/.local/bin/cursor
#!/bin/bash
~/.local/bin/Cursor --no-sandbox "$@"
EOF
chmod +x ~/.local/bin/cursor

# Add ~/.local/bin to PATH if not already present
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  export PATH="$HOME/.local/bin:$PATH"
fi

# Create .desktop launcher

# Create .desktop launcher with absolute paths
cat << EOF > ~/.local/share/applications/cursor.desktop
[Desktop Entry]
Name=Cursor
Exec=/home/lg/.local/bin/cursor %U
Icon=/home/lg/.local/share/icons/cursor-icon.png
Type=Application
Categories=Development;
StartupNotify=true
Terminal=false
EOF

# Optionally, add a comment about AppImage dependencies
# Note: If Cursor does not start, ensure FUSE/AppImage dependencies are installed:
# sudo apt install fuse libfuse2 || true

# Refresh desktop database
update-desktop-database ~/.local/share/applications || true

echo "✅ Cursor setup complete!"
echo "👉 Use 'cursor .' in terminal or launch it from the app menu."
