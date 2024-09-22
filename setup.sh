#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

cmdCheck() {
  if [ $? -eq 0 ]; then
    printf "%b\n" "${GREEN}**SUCCESS**${RESET}"
  else
    printf "%b\n" "${RED}**FAIL**${RESET}"
  fi
}

checkFolderStatus() {
  CONFIG_DIR="$HOME/.config"
  BASE_DIR="$HOME/i3/.config/"
  dir_paths=("i3" "i3status" "rofi" "dunst" "nitrogen" "picom")
  printf "%b\n" "${CYAN}Checking folder status${RESET}"
  for folder in "${dir_paths[@]}"; do
    if [ -e "$HOME/.config/$folder" ]; then
      printf "%b\n" "${YELLOW} ***$HOME/.config/$folder exist*** ${RESET}"
      printf "%b\n" "${RED} **Removing the existing $folder directory** ${RESET}"
      rm -rf "$HOME/.config/$folder"
      printf "%b\n" "${CYAN} *Creating symlink for $folder directory* ${RESET}"
      ln -s "$BASE_DIR/$folder" "$CONFIG_DIR"
      cmdCheck
    else
      printf "%b\n" "${RED} **$HOME/.config/$folder does not exist** ${RESET}"
      printf "%b\n" "${CYAN} *Creating symlink for $folder directory* ${RESET}"
      ln -s "$BASE_DIR/$folder" "$CONFIG_DIR"
      cmdCheck
    fi
  done
  printf "%b\n" "${CYAN} Copying touchpad config file ${RESET}"
  if [ -e /etc/X11/xorg.conf.d/ ]; then
    sudo cp -r ~/i3/90-touchpad.conf /etc/X11/xorg.conf.d/
    cmdCheck
  fi
}

packageInstall() {
  packages=$(grep -vE "^\s#" "$HOME/i3/packages.txt" | tr "\n" " ")
  printf "\n%b\n" "${CYAN} **Installing ${RED}$packages${RESET}${CYAN}** ${RESET}"
  if command -v dnf &>/dev/null; then
    sudo dnf install $packages
  fi
}

checkFolderStatus
packageInstall
