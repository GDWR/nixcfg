{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-show-empty-plugins true 
          set -g @dracula-border-contrast true
          set -g @dracula-refresh-rate 10
          set -g @dracula-show-left-icon session
          set -g @dracula-plugins "ssh-session time mpc spotify-tui"
        '';
      }
    ];

    extraConfig = ''
      set -g mouse on
    '';
  };
}
