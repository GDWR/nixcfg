{ pkgs, ... }: {
  home.packages = with pkgs; [  neovide  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      telescope-nvim
      catppuccin-nvim
      lualine-nvim
      nvim-cmp
      cmp-nvim-lsp
      copilot-vim
      nvim-lspconfig
      gitsigns-nvim
      which-key-nvim
      luasnip
    ];
    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.o.number = true
      vim.o.relativenumber = true 
      vim.o.termguicolors = true

      -- Misc Keymaps
      vim.keymap.set("n", "<leader>c", "<cmd>bd!<cr>")

      -- Configure Telescope
      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "${pkgs.ripgrep}/bin/rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
          },
          pickers = {
            find_command = {
              "${pkgs.fd}/bin/fd",
            },
          },
	  file_ignore_patterns = {
	    ".git/",
	    "node_modules/",
	    "target/",
	    "dist/",
	    "result/",
	  },
        }
      }
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
      vim.keymap.set("n", "<leader>ft", "<cmd>Telescope<cr>")

      -- Setup & Configure nvim-tree.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup()
      vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<cr>")
      vim.keymap.set("n", "<leader>tr", "<cmd>NvimTreeRefresh<cr>")
      vim.keymap.set("n", "<leader>tg", "<cmd>NvimTreeFindFile<cr>")
      vim.keymap.set("n", "<leader>tf", "<cmd>NvimTreeFocus<cr>")

      -- Setup & Configure catppuccin 
      require("catppuccin").setup {
        integrations = {
          cmp = true,
          gitsigns = true,
	  markdown = true,
	  telescope = true,
	  which_key = true,
	  nvimtree = true,
	  native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },

        },
      }
      vim.cmd[[colorscheme catppuccin-mocha]]

      -- Setup & Configure lualine
      require("lualine").setup {
        options = {
	  theme = "catppuccin",
	}
      }


      -- Setup & Configure nvim-cmp
      local cmp = require("cmp")
      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
	},
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'copilot' },
        })
      }
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Setup lspconfig
      local lspconfig = require('lspconfig')
      lspconfig.pyright.setup { capabilities = capabilities }
      lspconfig.tsserver.setup { capabilities = capabilities }
      lspconfig.rust_analyzer.setup { capabilities = capabilities }
      lspconfig.gopls.setup { capabilities = capabilities }
      
      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })

      -- Setup & Configure gitsigns
      require("gitsigns").setup()

      -- Setup & Configure which-key
      require("which-key").setup()
    '';
  };
}
