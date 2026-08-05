PROMPT='%F{green}%n@%m%f%~$ '

nix-list() {
  clear
  echo "List of installed nixpkgs: "
  cat /etc/nixos/packages.nix | grep -Fv "{ pkgs, ... }:" | grep -Fv "{" | grep -Fv "environment.systemPackages = with pkgs; [" | grep -Fv "];" | grep -Fv "}"
  echo ""
  echo "All the Nix packages..."
}

nix-install() {
  if [[ -z "$1" ]]; then
    echo "Usage: nix-install <package-name>"
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
  sudo sed -i "/^\s*\];/i \ \ \ \ $PKG" "$FILE" && \
  echo "installing nix $PKG..." && \
  sudo nixos-rebuild switch --quiet > /dev/null
  sleep 1
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
    sudo sed -i "/\b${PKG}\b/d" "$FILE" && \
    echo "removing nix $PKG..." && \
    sudo nixos-rebuild switch --quiet > /dev/null

    sleep 1
    echo ""
    echo "removed nixpkg $PKG successfully."
}

nix-update() {
  echo "(re)building system ..."
  sudo nixos-rebuild switch --upgrade --quiet > /dev/null
  sleep 1
  echo ""
  echo "Rebuilt the system."
}
