{pkgs, ...}: {
  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    settings = {
      global = {
        # Display
        monitor = 0;
        follow = "keyboard";

        # Geometry
        width = "(420, 1200)";
        height = "(0, 300)";
        origin = "top-right";
        offset = "(3, 3)";
        scale = 0;
        notification_limit = 0;

        # Progress bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        # Other display settings
        indicate_hidden = true;
        transparency = 22;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 2;
        frame_color = "#aaaaaa";
        gap_size = 5;
        sort = true;

        # Text
        font = "JetBrainsMono Nerd Font 10";
        line_height = 2;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        # Icons
        enable_recursive_icon_lookup = true;
        icon_theme = "Papirus, Adwaita";
        icon_position = "left";
        min_icon_size = 22;
        max_icon_size = 64;

        # History
        sticky_history = true;
        history_length = 20;

        # Misc/Advanced
        # dmenu = "/usr/bin/rofi -config \"/home/mn/.config/rofi/notification.rasi\" -dmenu -p dunst:";
        # browser = "/usr/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 4;
        ignore_dbusclose = false;

        # Mouse
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_current";
        mouse_right_click = "context";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      urgency_low = {
        background = "#131313AA";
        foreground = "#FCFCFCE6";
        frame_color = "#82828203";
        icon = "${pkgs.papirus-icon-theme}/share/icons/Papirus/128x128/apps/minigalaxy.svg";
        timeout = 5;
      };

      urgency_normal = {
        background = "#131313AA";
        foreground = "#FCFCFCE6";
        frame_color = "#2B2B2B03";
        icon = "${pkgs.papirus-icon-theme}/share/icons/Papirus/128x128/apps/minigalaxy.svg";
        timeout = 5;
      };
    };
  };
}
