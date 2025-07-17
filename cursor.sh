#!/bin/bash

set -e

echo "📥 Downloading Cursor AppImage and icon..."

# Cursor AppImage URL (example version 1.2.2)
CURSOR_APPIMAGE_URL="https://github.com/antfu/cursor/releases/download/v1.2.2/Cursor-1.2.2-x86_64.AppImage"
ICON_URL="https://img.icons8.com/?size=512&id=DiGZkjCzyZXn&format=png"

# Create required directories
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/icons
mkdir -p ~/.local/share/applications

# Download Cursor AppImage
curl -L -o ~/.local/bin/Cursor "$CURSOR_APPIMAGE_URL"
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
cat << EOF > ~/.local/share/applications/cursor.desktop
[Desktop Entry]
Name=Cursor
Exec=$HOME/.local/bin/Cursor --no-sandbox
Icon=$HOME/.local/share/icons/cursor-icon.png
Type=Application
Categories=Development;
StartupNotify=true
Terminal=false
EOF

# Refresh desktop database
update-desktop-database ~/.local/share/applications || true

echo "✅ Cursor setup complete!"
echo "👉 Use 'cursor .' in terminal or launch it from the app menu."
