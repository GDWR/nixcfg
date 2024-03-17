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
    ];
    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.o.number = true
      vim.o.relativenumber = true 
      vim.opt.termguicolors = true

      -- Misc Keymaps
      vim.keymap.set("n", "<leader>c", "<cmd>bd!<cr>")

      -- Configure Telescope
      require("telescope").setup()
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
    '';
  };
}
