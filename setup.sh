# Install Termux packages
pkg update
pkg upgrade -y
pkg install openssh git curl tar zstd

# Enable glibc repo
pkg install glibc-repo

# Install glibc runtime
pkg install glibc glibc-runner

# Start sshd
passwd
sshd -p 8022

# Connect from VS Code once and let it fail/install .vscode-server-insiders

# Find commit
ls ~/.vscode-server-insiders/bin

# Patch VS Code Server node
COMMIT="<commit-from-above>"
ROOT="$HOME/.vscode-server-insiders/bin/$COMMIT"
NODE="$ROOT/node"

cp -a "$NODE" "$ROOT/node.real"

cat > "$NODE" <<'EOF'
#!/data/data/com.termux/files/usr/bin/sh
exec /data/data/com.termux/files/usr/bin/glibc-runner --no-linker "$0.real" "$@"
EOF

chmod +x "$NODE"

# Verify
"$NODE" --version
"$NODE" --dns-result-order=ipv4first -e 'console.log("ok")'

# Restart server
pkill -f vscode-server-insiders 2>/dev/null
rm -f ~/.vscode-server-insiders/*.pid