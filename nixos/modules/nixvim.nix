{ pkgs, ... }:

let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "nixos-25.05";
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
        pkgs.vimPlugins.glow-nvim
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
            ts_ls.enable = true; # TS/JS
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

      extraConfigLua = ''
        -- Side-by-side markdown preview with glow
        local preview_buf = nil
        local preview_win = nil
        local preview_term = nil

        local function update_preview()
          local current_file = vim.fn.expand('%:p')
          if vim.fn.filereadable(current_file) == 0 then
            return
          end

          -- Create split if doesn't exist
          if not preview_win or not vim.api.nvim_win_is_valid(preview_win) then
            vim.cmd('vsplit')
            vim.cmd('wincmd l')
            preview_win = vim.api.nvim_get_current_win()

            -- Create terminal buffer running glow
            preview_term = vim.fn.termopen('glow ' .. vim.fn.shellescape(current_file), {
              on_exit = function()
                preview_term = nil
              end
            })
            preview_buf = vim.api.nvim_get_current_buf()

            vim.cmd('wincmd h')
          else
            -- Update existing preview
            if preview_term then
              vim.fn.jobstop(preview_term)
            end

            -- Clear and update the terminal
            vim.api.nvim_buf_set_option(preview_buf, 'modifiable', true)
            vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, {})

            vim.api.nvim_win_call(preview_win, function()
              preview_term = vim.fn.termopen('glow ' .. vim.fn.shellescape(current_file))
            end)
          end
        end

        vim.api.nvim_create_user_command('MarkdownPreview', update_preview, {})

        -- Auto-update on save
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = "*.md",
          callback = function()
            if preview_win and vim.api.nvim_win_is_valid(preview_win) then
              update_preview()
            end
          end,
        })

        -- Unwrap prose paragraphs while preserving code blocks, lists, and headings
        function _G.unwrap_markdown_paragraphs()
          local in_code_block = false
          local line_num = 1
          local total_lines = vim.fn.line('$')

          while line_num <= total_lines do
            local line = vim.fn.getline(line_num)
            local should_process = true

            -- Toggle code block flag
            if line:match('^```') then
              in_code_block = not in_code_block
              should_process = false
            end

            -- Skip if in code block, blank line, or heading
            if should_process and (in_code_block or
               line:match('^%s*$') or
               line:match('^#')) then
              should_process = false
            end

            -- Handle list items (numbered or bulleted)
            if should_process and (line:match('^%s*[%d]+%.') or line:match('^%s*[%-*]%s')) then
              -- Find end of list item (join continuation lines)
              local end_line = line_num
              while end_line < total_lines do
                local next_line = vim.fn.getline(end_line + 1)
                -- Stop at blank line, code block, heading, or new list item
                if next_line:match('^%s*$') or
                   next_line:match('^```') or
                   next_line:match('^#') or
                   next_line:match('^%s*[%d]+%.') or
                   next_line:match('^%s*[%-*]%s') then
                  break
                end
                -- Only join lines that are clearly continuations (start with lowercase)
                -- Don't join lines that look like they could be new content
                if next_line:match('^[a-z]') then
                  end_line = end_line + 1
                else
                  break
                end
              end

              -- Join the list item
              if end_line > line_num then
                vim.cmd(line_num .. ',' .. end_line .. 'j')
              end

              total_lines = vim.fn.line('$')
              should_process = false
            end

            -- If it's a prose paragraph (starts with letter)
            if should_process and line:match('^[A-Za-z]') then
              -- Find end of paragraph (only join consecutive non-blank lines)
              local end_line = line_num
              while end_line < total_lines do
                local next_line = vim.fn.getline(end_line + 1)
                -- Stop at blank line, code block, heading, or list
                if next_line:match('^%s*$') or
                   next_line:match('^```') or
                   next_line:match('^#') or
                   next_line:match('^%s*[%-*]') or
                   next_line:match('^%s*[%d]+%.') then
                  break
                end
                -- Only continue if next line starts with a letter or opening paren (prose continues)
                if not (next_line:match('^[A-Za-z]') or next_line:match('^%(')) then
                  break
                end
                end_line = end_line + 1
              end

              -- Join the paragraph
              if end_line > line_num then
                vim.cmd(line_num .. ',' .. end_line .. 'j')
              end

              -- Update total lines after joining
              total_lines = vim.fn.line('$')
            end

            line_num = line_num + 1
          end

          print("Unwrapped prose paragraphs")
        end
      '';

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
          action = "<cmd>lua require('vandelay').format_current_line()<cr>";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          mode = "n";
          key = "<leader>mp";
          action = "<cmd>MarkdownPreview<cr>";
          options = {
            desc = "Open markdown preview in split";
          };
        }
        {
          mode = "n";
          key = "<leader>mu";
          action = "<cmd>lua _G.unwrap_markdown_paragraphs()<cr>";
          options = {
            desc = "Unwrap hard-wrapped paragraphs";
            noremap = true;
            silent = true;
          };
        }
      ];
    };
  };
}
