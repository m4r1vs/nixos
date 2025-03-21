{pkgs, ...}: {
  services.swaync = {
    enable = true;
    package = pkgs.swaynotificationcenter;
    style =
      /*
      css
      */
      ''
        * {
          all: unset;
          font-size: 14px;
          font-family: "JetBrainsMono NF";
          transition: 200ms;
        }

        trough highlight {
          background: #D6D6D6;
        }

        scale trough {
          margin: 0rem 1rem;
          background-color: ${(import ../../theme.nix).backgroundColor};
          min-height: 8px;
          min-width: 70px;
        }

        slider {
            background-color: ${(import ../../theme.nix).primaryColor};
        }

        .floating-notifications.background .notification-row .notification-background {
          box-shadow: 0 3px 6px rgba(0,0,0,0.26), 0 3px 6px rgba(0,0,0,0.23);
          border-radius: 5px 0 0 5px;
          margin: 18px 0 18px 18px;
          background-color: ${(import ../../theme.nix).backgroundColor};
          color: #D6D6D6;
          padding: 0;
        }

        .floating-notifications.background .notification-row .notification-background .notification {
          padding: 7px;
          border-radius: 5px;
        }

        .floating-notifications.background .notification-row .notification-background .notification.critical {
          box-shadow: inset 0 0 2px 0 ${(import ../../theme.nix).primaryColor};
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content {
          margin: 7px;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content .summary {
          color: #D6D6D6;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content .time {
          color: #D6D6D6;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content .body {
          color: #D6D6D6;
        }

        .floating-notifications.background .notification-row .notification-background .notification>*:last-child>* {
          min-height: 3.4em;
        }

        .floating-notifications.background .notification-row .notification-background .notification>*:last-child>* .notification-action {
          border-radius: 4px;
          color: #D6D6D6;
          background-color: ${(import ../../theme.nix).primaryColor};
          margin: 7px;
        }

        .floating-notifications.background .notification-row .notification-background .notification>*:last-child>* .notification-action:hover {
          background-color: #272629;
          color: #D6D6D6;
        }

        .floating-notifications.background .notification-row .notification-background .notification>*:last-child>* .notification-action:active {
          background-color: #272629;
          color: #D6D6D6;
        }

        .floating-notifications.background .notification-row .notification-background .close-button {
          margin: 7px;
          padding: 2px;
          border-radius: 4px;
          color: ${(import ../../theme.nix).backgroundColor};
          background-color: ${(import ../../theme.nix).primaryColor};
        }

        .floating-notifications.background .notification-row .notification-background .close-button:hover {
          background-color: #272629;
          color: ${(import ../../theme.nix).backgroundColor};
        }

        .floating-notifications.background .notification-row .notification-background .close-button:active {
          background-color: #272629;
          color: ${(import ../../theme.nix).backgroundColor};
        }

        .control-center {
          margin: 0;
          background-color: transparent;
          color: #D6D6D6;
          padding: 0px;
        }

        .control-center .widget-title {
          box-shadow: 0 3px 6px rgba(0,0,0,0.26), 0 3px 6px rgba(0,0,0,0.23);
          margin: 18px;
          padding: 14px;
          border-radius: 5px;
          background-color: ${(import ../../theme.nix).backgroundColor};
        }

        .control-center .widget-title>label {
          color: #D6D6D6;
          font-size: 1.3em;
        }

        .control-center .widget-title button {
          border-radius: 4px;
          color: #D6D6D6;
          background-color: ${(import ../../theme.nix).primaryColor};
          padding: 8px;
        }

        .control-center .widget-title button:hover {
          background-color: #272629;
          color: #D6D6D6;
        }

        .control-center .widget-title button:active {
          background-color: #272629;
          color: #D6D6D6;
        }

        .widget-dnd {
          box-shadow: 0 3px 6px rgba(0,0,0,0.26), 0 3px 6px rgba(0,0,0,0.23);
          padding: 14px;
          border-radius: 5px;
          background-color: ${(import ../../theme.nix).backgroundColor};
          margin: 0 18px 18px 18px;
          font-size: 1.1rem;
        }

        .widget-dnd>switch {
          font-size: initial;
          border-radius: 4px;
          background: ${(import ../../theme.nix).backgroundColor};
          box-shadow: none;
        }

        .widget-dnd>switch:checked {
          background: ${(import ../../theme.nix).backgroundColor};
        }

        .widget-dnd>switch slider {
          border-radius: 4px;
          border: 0px;
        }

        .control-center .notification-row {
          padding: 0px 0px 0px 18px;
          margin: 0 0 0 18px;
        }

        .control-center .notification-row .notification-background {
          box-shadow: 0 3px 6px rgba(0,0,0,0.26), 0 3px 6px rgba(0,0,0,0.23);
          border-radius: 5px 0 0 5px;
          color: #D6D6D6;
          background-color: ${(import ../../theme.nix).backgroundColor};
          margin: 5px 0px 5px 0;
        }

        .control-center .notification-row .notification-background .notification {
          padding: 7px;
        }

        .control-center .notification-row .notification-background .notification.critical {
          box-shadow: inset 0 0 7px 0 ${(import ../../theme.nix).primaryColor};
        }

        .control-center .notification-row .notification-background .notification .notification-content {
          margin: 7px;
        }

        .control-center .notification-row .notification-background .notification .notification-content .summary {
          color: #D6D6D6;
        }

        .control-center .notification-row .notification-background .notification .notification-content .time {
          color: #D6D6D6;
        }

        .control-center .notification-row .notification-background .notification .notification-content .body {
          color: #D6D6D6;
        }

        .control-center .notification-row .notification-background .notification>*:last-child>* {
          min-height: 3.4em;
        }

        .control-center .notification-row .notification-background .notification>*:last-child>* .notification-action {
          border-radius: 4px;
          color: #D6D6D6;
          background-color: ${(import ../../theme.nix).primaryColor};
          margin: 7px;
        }

        .control-center .notification-row .notification-background .notification>*:last-child>* .notification-action:hover {
          background-color: #272629;
          color: #D6D6D6;
        }

        .control-center .notification-row .notification-background .notification>*:last-child>* .notification-action:active {
          background-color: #272629;
          color: #D6D6D6;
        }

        .control-center .notification-row .notification-background .close-button {
          margin: 7px;
          padding: 2px;
          border-radius: 4px;
          color: ${(import ../../theme.nix).backgroundColor};
          background-color: ${(import ../../theme.nix).primaryColor};
        }

        .close-button {
          border-radius: 4px;
        }

        .control-center .notification-row .notification-background .close-button:hover {
          background-color: ${(import ../../theme.nix).primaryColor};
          color: ${(import ../../theme.nix).backgroundColor};
        }

        .control-center .notification-row .notification-background .close-button:active {
          background-color: ${(import ../../theme.nix).primaryColor};
          color: ${(import ../../theme.nix).backgroundColor};
        }

        .control-center .notification-row .notification-background:hover {
          background-color: #272629;
          color: #D6D6D6;
        }

        .control-center .notification-row .notification-background:active {
          background-color: #272629;
          color: #D6D6D6;
        }

        .notification.critical progress {
          background-color: ${(import ../../theme.nix).primaryColor};
        }

        .notification.low progress,
        .notification.normal progress {
          background-color: ${(import ../../theme.nix).primaryColor};
        }

        .control-center-dnd {
          margin-top: 5px;
          border-radius: 5px;
          background: ${(import ../../theme.nix).backgroundColor};
        }

        .control-center-dnd:checked {
          background: ${(import ../../theme.nix).backgroundColor};
        }

        .control-center-dnd slider {
          border-radius: 4px;
        }

        .widget-mpris .widget-mpris-player {
            background: ${(import ../../theme.nix).backgroundColor};
            padding: 7px;
        }

        .widget-mpris .widget-mpris-title {
            font-size: 1.2rem;
        }

        .widget-mpris .widget-mpris-subtitle {
            font-size: 0.8rem;
        }

        .widget-menubar>box>.menu-button-bar>button>label {
            font-size: 3rem;
            padding: 0.5rem 2rem;
        }

        .widget-menubar>box>.menu-button-bar>:last-child {
            color: ${(import ../../theme.nix).primaryColor};
        }

        .power-buttons button:hover,
        .powermode-buttons button:hover,
        .screenshot-buttons button:hover {
          background-color: #272629;
        }

        .control-center .widget-label>label {
          color: #D6D6D6;
          font-size: 2rem;
        }

        .widget-buttons-grid {
            padding-top: 1rem;
        }

        .widget-buttons-grid>flowbox>flowboxchild>button label {
            font-size: 2.5rem;
        }

        .widget-volume {
            padding-top: 1rem;
        }

        .widget-volume label {
            font-size: 1.5rem;
            color: #ff00ff;
        }

        .widget-volume trough highlight {
            background: #ff00ff;
        }

        .widget-backlight trough highlight {
            background: #00ffff;
        }

        .widget-backlight label {
            font-size: 1.5rem;
            color: #00ffff;
        }

        .widget-backlight .KB {
            padding-bottom: 1rem;
        }

        .image {
          padding-right: 0.5rem;
        }
      '';
    settings = {
      positionX = "right";
      control-center-positionX = "right";
      positionY = "top";
      layer = "overlay";
      text-empty = " 󰾢 ";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = true;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      widgets = [
        "title"
        "dnd"
        "notifications"
      ];
      widget-config = {
        title = {
          text = " Notifications";
          clear-all-button = true;
          button-text = " 󰎟 ";
        };
        dnd = {
          text = "󰖔 Do Not Disturb";
        };
      };
    };
  };
}
