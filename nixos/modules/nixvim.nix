{ pkgs, ... }:

let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # ref = "nixos-24.05";
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
      defaultEditor = true;
      extraPlugins = [ pkgs.vimPlugins.gruvbox ];
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
  };
}
