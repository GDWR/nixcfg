{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
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
      # to enable mouse scroll, see https://github.com/tmux/tmux/issues/145#issuecomment-150736967
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"
    '';
  };
}
