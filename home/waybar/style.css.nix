# css
''
  * {
    border: none;
    border-radius: 0px;
    font-family: "JetBrainsMono Nerd Font Propo";
    font-weight: bold;
    font-size: 10px;
    min-height: 10px;
  }

  @define-color bar-bg rgba(0,0,0,0);
  @define-color main-bg ${(import ../../theme.nix).backgroundColor};
  @define-color main-fg rgba(214,214,214,1);
  @define-color wb-act-bg ${(import ../../theme.nix).primaryColor};
  @define-color wb-act-fg rgba(252,252,252,1);
  @define-color wb-hvr-bg rgba(61,61,61,0.4);
  @define-color wb-hvr-fg rgba(214,214,214,0.8);

  window#waybar {
    background: @bar-bg;
  }

  tooltip {
    background: @main-bg;
    color: @main-fg;
    border-radius: 4px;
    border-width: 0px;
  }

  #workspaces button {
    box-shadow: none;
    text-shadow: none;
    padding: 0px;
    border-radius: 3px;
    margin-top: 2px;
    margin-bottom: 2px;
    margin-left: 0px;
    padding-left: 2px;
    padding-right: 2px;
    margin-right: 0px;
    color: @main-fg;
    animation: ws_normal 20s ease-in-out 1;
  }

  #workspaces button.active {
    background: @wb-act-bg;
    color: @wb-act-fg;
    margin-left: 2px;
    padding-left: 11px;
    padding-right: 11px;
    margin-right: 2px;
    animation: ws_active 20s ease-in-out 1;
    transition: all 0.4s cubic-bezier(0.55, -0.68, 0.48, 1.682);
  }

  #workspaces button:hover {
    background: @wb-hvr-bg;
    color: @wb-hvr-fg;
    animation: ws_hover 20s ease-in-out 1;
    transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
  }

  #taskbar button {
    box-shadow: none;
    text-shadow: none;
    padding: 0px;
    border-radius: 3px;
    margin-top: 2px;
    margin-bottom: 2px;
    margin-left: 0px;
    padding-left: 2px;
    padding-right: 2px;
    margin-right: 0px;
    color: @wb-color;
    animation: tb_normal 20s ease-in-out 1;
  }

  #taskbar button.active {
    background: @wb-act-bg;
    color: @wb-act-color;
    margin-left: 2px;
    padding-left: 11px;
    padding-right: 11px;
    margin-right: 2px;
    animation: tb_active 20s ease-in-out 1;
    transition: all 0.4s cubic-bezier(0.55, -0.68, 0.48, 1.682);
  }

  #taskbar button:hover {
    background: @wb-hvr-bg;
    color: @wb-hvr-color;
    animation: tb_hover 20s ease-in-out 1;
    transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
  }

  #tray menu * {
    min-height: 16px;
  }

  #tray menu separator {
    min-height: 10px;
  }

  #backlight,
  #battery,
  #bluetooth,
  #custom-cava,
  #custom-cliphist,
  #clock,
  #custom-cpuinfo,
  #cpu,
  #custom-gpuinfo,
  #idle_inhibitor,
  #custom-keybindhint,
  #language,
  #memory,
  #mpris,
  #network,
  #custom-notifications,
  #custom-power,
  #privacy,
  #pulseaudio,
  #custom-media,
  #custom-webcam,
  #custom-weather,
  #taskbar,
  #custom-theme,
  #tray,
  #custom-updates,
  #custom-wallchange,
  #custom-wbar,
  #window,
  #workspaces,
  #custom-l_end,
  #custom-r_end,
  #custom-sl_end,
  #custom-sr_end,
  #custom-rl_end,
  #custom-rr_end {
    color: @main-fg;
    background: @main-bg;
    opacity: 1;
    margin: 3px 0px 3px 0px;
    padding-left: 4px;
    padding-right: 4px;
  }

  #workspaces,
  #taskbar {
    padding: 0px;
  }

  #custom-r_end {
    border-radius: 0px 4px 4px 0px;
    margin-right: 8px;
    padding-right: 0px;
  }

  #privacy-item {
    margin-left: 8px;
  }

  #custom-l_end {
    border-radius: 4px 0px 0px 4px;
    margin-left: 8px;
    padding-left: 0px;
  }

  #custom-sr_end {
    border-radius: 0px;
    margin-right: 8px;
    padding-right: 0px;
  }

  #custom-sl_end {
    border-radius: 0px;
    margin-left: 8px;
    padding-left: 0px;
  }

  #custom-rr_end {
    border-radius: 0px 4px 4px 0px;
    margin-right: 8px;
    padding-right: 0px;
  }

  #custom-rl_end {
    border-radius: 4px 0px 0px 4px;
    margin-left: 8px;
    padding-left: 0px;
  }
''
