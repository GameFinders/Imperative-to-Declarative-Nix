PROMPT='%F{green}%n@%m%f %~ [%F{red}%?%f] %# '

# Uncomment this if you use OpenDOAS
# (or replace the word 'sudo' with 'doas')
#alias sudo="doas"

nix-list() {
  clear
  echo "List of installed nixpkgs: "
  cat /etc/nixos/packages.nix | grep -Fv "{ pkgs, ... }:" | grep -Fv "{" | grep -Fv "environment.systemPackages = with pkgs; [" | grep -Fv "];" | grep -Fv "}"
  echo ""
  echo "All the Nix packages..."
}

nix-add() {
  if [[ -z "$1" ]]; then
    echo "Usage: nix-add <package-name>"
    return 1
  fi

  local PKG="$1"
  local FILE="/etc/nixos/packages.nix"

  # Ensure packages.nix exists before attempting to write
  if [[ ! -f "$FILE" ]]; then
    echo "E: $FILE does not exist at /nix/."
    return 1
  fi

  if grep -q -w "$PKG" "$FILE"; then
      echo "E: Package '$PKG' is already installed"
      return 1
  fi

  # Insert package name right before the closing '];' bracket
  sudo sed -i "/^\s*\];/i \ \ \ \ $PKG" "$FILE"
  if [[ $2 == "--wait" ]]; then
    echo "Added $PKG to /etc/nixos/packages.nix."
    echo "Waiting for rebuild command..."
    return 0
  fi
  echo "installing nixpkg $PKG..."
  sudo nixos-rebuild switch --quiet
  echo ""
  echo "Installed pkgs.$PKG successfully."
}

nix-remove() {
    if [[ -z "$1" ]]; then
        echo "Usage: nix-remove <package-name>"
        return 1
    fi

    local PKG="$1"
    local FILE="/etc/nixos/packages.nix"

    # Ensure packages.nix exists before attempting to write
    if [[ ! -f "$FILE" ]]; then
        echo "E: $FILE does not exist at /etc/nixos/."
        return 1
    fi

    # Check if the package is actually present in packages.nix
    if ! grep -q -w "$PKG" "$FILE"; then
        echo "E: Package $PKG is not in $FILE"
        return 1
    fi

    # Remove the package line from packages.nix and rebuild the system
    sudo sed -i "/\b${PKG}\b/d" "$FILE"
    if [[ $2 == "--wait" ]]; then
      echo "Added $PKG to /etc/nixos/packages.nix."
      echo "Waiting for rebuild command..."
      return 0
    fi
    echo "removing nixpkg $PKG..."
    sudo nixos-rebuild switch --quiet
    echo ""
    echo "removed nixpkg $PKG successfully."
}

nix-update() {
  echo "(re)building system ..."
  sudo nixos-rebuild switch --upgrade --quiet
  echo ""
  echo "Rebuilt the system."
}
