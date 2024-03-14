{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-surround
      neo-tree-nvim
    ];
    extraLuaConfig = ''
      vim.o.number = true
      vim.o.relativenumber = true

      vim.o.guifont = "JetBrains Mono:h14"
    '';
  };

  home.packages = with pkgs; [ neovide ];
}
