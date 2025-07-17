{ pkgs, ... }:

let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
  });
in
{
  imports =
    [
      nixvim.nixosModules.nixvim
    ];

  programs = {
    nixvim = {
      enable = true;
      autoCmd = [
        {
          event = [ "BufWritePre" ];
          pattern = [ "*" ];
          command = ":%s/\\s\\+$//e";
        }
      ];
      defaultEditor = true;
      extraPlugins = [
        pkgs.vimPlugins.gruvbox
        (pkgs.vimUtils.buildVimPlugin {
          pname = "nvim-vandelay";
          version = "2025-07-10";
          src = pkgs.fetchFromGitHub {
            owner = "ducks";
            repo = "nvim-vandelay";
            rev = "main";  # or a specific commit SHA
            sha256 = "0xiqs3dmca1x5310z2p0d1x91d6l3cnmnf83m47rnv6bin58zkv5";
          };
        })
      ];
      colorscheme = "gruvbox";

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
            tsserver.enable = true; # TS/JS
            lua-ls.enable = true; # lua
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
        };

        cmp-nvim-lsp = {
          enable = true;
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

        treesitter = {
          enable = true;
        };
      };


      keymaps = [
        {
          mode = "n";
          key = "<leader>w";
          action = "<cmd>write<cr>";
        }
        {
          mode = "n";
          key = "<leader>q";
          action = "<cmd>quit<cr>";
        }
        {
          mode = "n";
          key = "<leader><leader>";
          action = "/";
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>mi";
          action.__raw = "function() require('vandelay').format_current_line() end";
          options = {
            noremap = true;
            silent = true;
          };
        }
      ];
    };
  };
}
