{ config, pkgs, ... }:

let
  mycal = pkgs.callPackage ./packages/mycal.nix { };
in
{
  # ============================================================================
  # Imports
  # ============================================================================

  imports = [
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # Nix
  # ============================================================================

  nix = {
    settings = {
      auto-optimise-store = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  # ============================================================================
  # Boot
  # ============================================================================

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # ============================================================================
  # Hardware
  # ============================================================================

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  zramSwap.enable = true;

  # ============================================================================
  # Networking
  # ============================================================================

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # ============================================================================
  # Locale
  # ============================================================================

  time.timeZone = "Europe/Kyiv";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "uk_UA.UTF-8";
      LC_IDENTIFICATION = "uk_UA.UTF-8";
      LC_MEASUREMENT = "uk_UA.UTF-8";
      LC_MONETARY = "uk_UA.UTF-8";
      LC_NAME = "uk_UA.UTF-8";
      LC_NUMERIC = "uk_UA.UTF-8";
      LC_PAPER = "uk_UA.UTF-8";
      LC_TELEPHONE = "uk_UA.UTF-8";
      LC_TIME = "uk_UA.UTF-8";
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ============================================================================
  # User
  # ============================================================================

  users.users.sinx = {
    isNormalUser = true;
    description = "Artem";
    shell = pkgs.zsh;

    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # ============================================================================
  # Desktop / Wayland
  # ============================================================================

  programs.niri.enable = true;

  services.greetd = {
    enable = true;

    settings.default_session = {
      command = "${config.programs.niri.package}/bin/niri-session";
      user = "sinx";
    };
  };

  systemd.user.services.niri.enableDefaultPath = false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.polkit.enable = true;

  # ============================================================================
  # Keyring / Authentication
  # ============================================================================

  services.gnome.gnome-keyring.enable = true;

  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    hyprlock = { };
  };

  # ============================================================================
  # Audio
  # ============================================================================

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ============================================================================
  # Fonts
  # ============================================================================

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # ============================================================================
  # Packages
  # ============================================================================

  environment.systemPackages = with pkgs; [

    # --- Core / CLI ---
    fastfetch
    wget
    git
    btop
    nixfmt

    # --- Browser / apps ---
    firefox
    vscode
    vesktop
    stremio-linux-shell
    libreoffice
    vlc
    kdePackages.kdenlive
    zoom-us
    obsidian

    # --- Programming / development ---
    # C / C++
    gcc
    gdb
    cmake
    ninja
    clang-tools

    # C#
    dotnet-sdk_10

    # --- File management / GTK ---
    thunar
    papirus-icon-theme
    adwaita-icon-theme
    nwg-look
    peazip
    imv
    zathura

    # --- Wayland desktop ---
    foot
    fuzzel
    waybar
    starship
    awww
    swaybg
    hyprlock
    hypridle
    swayosd
    swaynotificationcenter
    xwayland-satellite

    # --- Calendar ---
    mycal

    # --- Theming ---
    matugen

    # --- Notifications ---
    libnotify

    # --- Audio ---
    easyeffects
    pwvucontrol
    alsa-utils

    # --- Brightness / input ---
    brightnessctl

    # --- Screenshots / clipboard ---
    wl-clipboard
    grim
    slurp

    # --- Graphics / video diagnostics ---
    libva-utils
    intel-gpu-tools

    # --- Secret storage ---
    libsecret
  ];

  # ============================================================================
  # System
  # ============================================================================

  system.stateVersion = "26.05";
}
