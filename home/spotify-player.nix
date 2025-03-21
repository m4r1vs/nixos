pkgs: {
  enable = true;
  package = with pkgs;
    rustPlatform.buildRustPackage {
      pname = "spotify-player";
      version = "latest";

      src = fetchFromGitHub {
        owner = "m4r1vs";
        repo = "spotify-player";
        rev = "master";
        hash = "sha256-VGEjSVacYXAEMg1GJQEacP1vxhtKYnTBc8h1QfekoHM=";
      };

      useFetchCargoVendor = true;
      cargoHash = "sha256-0vIhAJ3u+PfujUGI07fddDs33P35Q4CSDz1sMuQwVws=";
      nativeBuildInputs = [
        pkg-config
        cmake
        rustPlatform.bindgenHook
      ];
      buildInputs = [
        openssl
        dbus
        fontconfig
        libpulseaudio
      ];
      buildNoDefaultFeatures = true;
      buildFeatures = [
        "pulseaudio-backend"
        "media-control"
        "image"
        "daemon"
        "notify"
        "streaming"
        "fzf"
      ];
      passthru = {
        updateScript = nix-update-script {};
      };
    };
  keymaps = [
    {
      command = "None";
      key_sequence = "q";
    }
    {
      command = "None";
      key_sequence = "l";
    }
    {
      command = "PreviousPage";
      key_sequence = "h";
    }
    {
      command = "ChooseSelected";
      key_sequence = "l";
    }
    {
      command = "PreviousPage";
      key_sequence = "C-o";
    }
  ];
  settings = {
    theme = "dracula";
    client_port = 8080;
    login_redirect_uri = "http://127.0.0.1:8888/login";
    playback_format = ''
      {status} {track} • {artists}
      {album}
      {metadata}'';
    tracks_playback_limit = 50;
    app_refresh_duration_in_ms = 32;
    playback_refresh_duration_in_ms = 0;
    page_size_in_rows = 20;
    play_icon = " ";
    pause_icon = "󰕿";
    liked_icon = " ";
    border_type = "Double";
    progress_bar_type = "Rectangle";
    enable_cover_image_cache = true;
    enable_streaming = "Always";
    notify_streaming_only = true;
    default_device = "spotify-player";
    cover_img_width = 7;
    cover_img_length = 16;
    seek_duration_secs = 5;
    layout = {
      playback_window_position = "Bottom";
      playback_window_height = 6;
      library = {
        playlist_percent = 40;
        album_percent = 40;
      };
    };
    device = {
      name = "spotify-player";
      device_type = "speaker";
      volume = 100;
      bitrate = 320;
      audio_cache = true;
      normalization = false;
      autoplay = false;
    };
  };
}
