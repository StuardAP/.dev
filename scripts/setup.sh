#!/bin/sh

set -e

packages = "git neovim zsh starship bat"
failed = ""

check_command() {
    command -v "$1" >/dev/null 2>&1 || { echo >&2 "$1 is required but not installed. Aborting."; exit 1; }
}

check_command apk
check_command git
check_command sed


for pkg in $packages; do
    apk add --no-cache $pkg || {
      echo "Failed to install $pkg"
      failed = "$failed $pkg"
    }
done

if [ -n "$failed" ]; then
  echo "The following packages failed to install: $failed"
  exit 1
fi

chsh -s /bin/zsh

# Backup the original /etc/passwd file
cp /etc/passwd /etc/passwd.bak

sed -i.bak -e '/^root:/ s#/bin/ash#/#' -e '/^node:/ s#/bin/sh# #;/^node:/ s#^#&#' -e 's#^root:x:0:0:root:/root:/bin/zsh#&\n#' -e '/^node:/ s#/bin/sh#/bin/zsh#' /etc/passwd

if [! -d "~/.config"]; then
  git clone https://github.com/StuardAP/.dev.git ~/.config
fi

if [ -f "~/.config/.zshrc" ]; then
  cp ~/.config/.zshrc ~/
fi

if [ -f ~/config/binaries/lsd ]; then
  mv ~/.config/binaries/lsd /bin
fi

echo "Script executed successfully"

exec zsh
