{ config, pkgs, lib, ... }:

with lib;
let cfg = config.profiles.shell.tmux;
in {
  options.profiles.shell.tmux = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users."${config.vars.username}".programs.tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 100000;
      keyMode = "vi";
      prefix = "C-c";
      secureSocket = true;
      sensibleOnTop = false;
      terminal = "tmux-256color";
      plugins = with pkgs.tmuxPlugins; [
        yank
        open
        copycat
        prefix-highlight
        tmux-thumbs
      ];
      extraConfig = ''
        # For terminals that support them, propagate these events to programs that
        # understand them.
        set  -s focus-events on
        # Enable mouse + mouse wheel
        # Rebind prefix to C-c. Press twice to send literal C-c.
        set  -g mouse on
        set -g prefix C-c
        bind C-c send-prefix

        ############
        # BINDINGS #
        ############
        set -g @thumbs-key Y
        bind-key ê thumbs-pick

        bind N new-window      -c "#{pane_current_path}"
        bind n new-window
        bind v split-window -h -c "#{pane_current_path}"
        bind k split-window -v -c "#{pane_current_path}"

        bind c select-pane -L
        bind t select-pane -D
        bind s select-pane -U
        bind r select-pane -R

        bind o resize-pane -Z
        bind , choose-session
        bind . choose-window

        bind ° select-layout tiled
        bind | select-layout even-horizontal
        bind _ select-layout even-vertical

        # Disable confirmation
        bind x kill-pane
        bind X kill-window
        bind q kill-session
        bind Q kill-server

        bind C-n next-window
        bind C-p previous-window

        # break pane into a window
        bind = select-layout even-vertical
        bind + select-layout even-horizontal
        bind - break-pane
        bind _ join-pane

        ########################################
        # Copy mode                            #
        ########################################

        bind Enter copy-mode # enter copy mode
        bind b list-buffers  # list paster buffers
        bind B choose-buffer # choose which buffer to paste from
        bind p paste-buffer  # paste from the top paste buffer
        bind P run "xclip -selection clipboard -o | tmux load-buffer - ; tmux paste-buffer"

        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind -T copy-mode-vi Escape send-keys -X cancel
        bind -T copy-mode-vi C-g send-keys -X cancel
        bind -T copy-mode-vi c send-keys -X cursor-left
        bind -T copy-mode-vi t send-keys -X cursor-down
        bind -T copy-mode-vi s send-keys -X cursor-up
        bind -T copy-mode-vi r send-keys -X cursor-right
        bind -T copy-mode-vi C send-keys -X start-of-line
        bind -T copy-mode-vi R send-keys -X end-of-line

        set -g @open-editor 'C-e'

        ###########
        # SESSION #
        ###########
        # make inactive window's background dimmer
        set -g window-active-style bg=#161e22
        set -g window-style bg=terminal

        # renumber windows when a window is closed
        set -g renumber-windows on

        # disable running multiple commands pressing the prefix once
        set -g repeat-time 0

        # enable both visual message and bell on activity alerts
        set -g monitor-activity on
        set -g visual-activity on

        # tmux messages are displayed for 4 seconds
        set -g display-time 4000

        set -ga terminal-overrides ",${config.vars.terminal}:Tc"

        ##########
        # VISUAL #
        ##########
        # jellybeans theme created with tmuxline
        set -g status-justify "left"
        set -g status "on"
        set -g status-left-style "none"
        set -g message-command-style "fg=colour253,bg=colour239"
        set -g status-right-style "none"
        set -g pane-active-border-style "fg=colour103"
        set -g status-style "none,bg=colour236"
        set -g message-style "fg=colour253,bg=colour239"
        set -g pane-border-style "fg=colour239"
        set -g status-right-length "100"
        set -g status-left-length "100"
        setw -g window-status-activity-style "none"
        setw -g window-status-separator ""
        setw -g window-status-style "none,fg=colour244,bg=colour236"
        set -g status-left "#[fg=colour236,bg=colour103] #S #[fg=colour103,bg=colour236,nobold,nounderscore,noitalics]"
        set -g status-right "#[fg=colour239,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour248,bg=colour239] %Y-%d-%m  %H:%M #[fg=colour246,bg=colour239,nobold,nounderscore,noitalics]#[fg=colour236,bg=colour246] #h "
        setw -g window-status-format "#[fg=colour244,bg=colour236] #I #[fg=colour244,bg=colour236] #W "
        setw -g window-status-current-format "#[fg=colour236,bg=colour239,nobold,nounderscore,noitalics]#[fg=colour253,bg=colour239] #I #[fg=colour253,bg=colour239] #W #[fg=colour239,bg=colour236,nobold,nounderscore,noitalics]"
      '';
    };
  };
}
