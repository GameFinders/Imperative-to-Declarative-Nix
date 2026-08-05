{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Hint: to blacklist a package, place a hash behind it. Example:
    #kitty
    # the ZSH function nix-install should assume the package exists. When you run:
    #  user@nixuser $ nix-remove kitty <--(EXAMPLE!)--#
    # the package should be de-blacklisted and you can reinstall it again with
    #  user@nixuser $ nix-install kitty <--(EXAMPLE!)--#
  ];
}
