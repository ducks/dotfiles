# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ 
  config,
  lib,
  pkgs,
  ... 
}: 
let
  berkeley-mono = pkgs.callPackage ./packages/berkeley-mono.nix { };
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
  });
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      nixvim.nixosModules.nixvim
    ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs = {
    nixvim = {
      enable = true;
      defaultEditor = true;
      colorschemes.gruvbox.enable = true;

      globals = {
        mapleader = " ";
      };

      # TODO: modularize nixvim config
      opts = {
        background = "dark"; 
        number = true;
        
        colorcolumn = "80";
        
        updatetime = 50;
        
        hlsearch = false;
        ignorecase = true;
        
        swapfile = false;
        
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        smartindent = true;
      };

      plugins = {
        lsp = {
          enable = true;


          keymaps = {
            diagnostic = {
              "<leader>j" = "goto_next";
              "<leader>k" = "goto_prev";
            };
          };

          servers = {
            #ts-ls.enable = true; # TS/JS
            lua_ls.enable = true; # lua
          };
        };

        luasnip = {
          enable = true;
        };

        nvim-autopairs = {
          enable = true;
        };

        rustaceanvim = {
          enable = true;
          settings = {
            server = {
              standalone = true;
            };
          };
        };

        lualine = {
          enable = true;

          settings.options.theme = "gruvbox";
        };

        cmp = {
          enable = true;
          autoEnableSources = true;

          settings = {
            mapping = {
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<C-j>" = "cmp.mapping.select_next_item()";
              "<C-k>" = "cmp.mapping.select_prev_item()";
              "<C-e>" = "cmp.mapping.abort()";
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-CR>" = "cmp.mapping.confirm({ select = true })";
            };

            snippet = {
              expand = "function(args) require('luasnip').lsp_expand(args.body) end";
            };

            sources = [
              { name = "nvim_lsp"; }
              { name = "nvim_lua"; }
              { name = "path"; }
              { name = "buffer"; }
              { name = "luasnip"; }
            ]; 
          };
        };

        # TODO: fix treesitter errors
        # treesitter = {
        #   enable = true;
        # };
      };
    };
    sway = {
      enable = true;
    };
    hyprland = {
      enable = true;
    };

    light = {
      enable = true;

      brightnessKeys = {
        enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    git
    librewolf
    wezterm
    clang
    rustup
    nodejs_22
  ];

  fonts.packages = with pkgs; [
    berkeley-mono 
  ];

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    systemWide = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  users.users = {
    disco = {
      isNormalUser = true;
      home = "/home/disco";
      extraGroups = [ "wheel" "networkmanager" "video"];
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

