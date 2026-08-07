# Nix to Sinless Imperative

the repo itself is licensed under the WTFPL license.

i know why. i don't want GNU License on Nix files.

# How to use it

1. download the .zshrc
2. download the packages.nix
3. clone or move .zshrc to /home/user/.zshrc
4. clone or move packages.nix to /etc/nixos/packages.nix
5. import packages.nix in configuration.nix it should look like:
> Code:

```imports =
  [
    ./hardware-configuration.nix
    ./packages.nix
  ];
```

6. make sure you have ZSH
7. enjoy!

Commands are:
> nix-add [pkg]:
  adds package.

> nix-remove [pkg]:
  removes package.

> nix-list:
  lists packages in /etc/nixos/packages.nix file.

# New Additions: Built-in OpenDOAS to SUDO alias

to use this, uncomment the line "#alias sudo='doas'".
