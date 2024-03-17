{ pkgs, ... }: {
  home.packages = with pkgs; [  neovide  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      neo-tree-nvim
      telescope-nvim

      nvim-lspconfig
    ];
    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.o.number = true
      vim.o.relativenumber = true 

      -- General keybinds
      vim.keymap.set("n", "<leader>c", "<cmd>bd!<cr>")

      -- Configure Telescope
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")

      -- Configure Neotree
      vim.keymap.set("n", "<leader>t", "<cmd>Neotree toggle<cr>")
    '';
  };
}
