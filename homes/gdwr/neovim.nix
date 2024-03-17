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
      copilot-vim
      nvim-lspconfig
      gitsigns-nvim
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
      require("catppuccin").setup()
      vim.cmd[[colorscheme catppuccin-mocha]]

      -- Setup & Configure lualine
      require("lualine").setup()

      -- Setup & Configure nvim-cmp
      require("cmp").setup()

      -- Setup lspconfig
      local lspconfig = require('lspconfig')
      lspconfig.pyright.setup {}
      lspconfig.tsserver.setup {}
      lspconfig.rust_analyzer.setup {}
      
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
    '';
  };
}
