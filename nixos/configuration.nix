{ config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    initrd.luks.reusePassphrases = true;
    initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/5f996bea-8c0d-4e33-b858-19323e3f5302";
        preLVM = true;
      };
      user = {
        device = "/dev/disk/by-uuid/89609626-f197-438d-918b-fe789ff858a3";
        preLVM = true;
      };
    };
  };

  fileSystems."root" =
  { 
    device = "/dev/disk/by-uuid/3bdbdbc1-c89a-47d4-a574-ba3e66c977f6";
    mountPoint = "/";
    options = [ "noatime" "nodiratime" "discard" ];
    fsType = "btrfs";
  };
    
  fileSystems."boot" =
  {
    device = "/dev/disk/by-uuid/8D43-701C";
    mountPoint = "/boot";
    options = [ "noatime" "nodiratime" "discard" ];
    fsType = "vfat";
  };
    
  fileSystems."user" =
  {
    device = "/dev/disk/by-uuid/3efcee78-2bc1-4311-9e0a-8105eabfea36";
    mountPoint = "/home/aviv";
    fsType = "ext4";
  };


  nixpkgs.config.allowUnfree = true;
  
  networking = {
    hostName = "nixos-20aws1hl002";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    useDHCP = false;
    interfaces.enp0s25.useDHCP = true;
    interfaces.wlp0s20u6.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  time.timeZone = "Asia/Jakarta";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "colemak";
  
  # List services enable:
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      layout = "us";
      xkbVariant = "colemak";
      libinput.enable = true;
      videoDrivers = [ "modesetting" ];
      useGlamor = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    # openssh.enable = true;
    earlyoom.enable = true;
    fstrim.enable = true;
    flatpak.enable = true;
    printing.enable = true;
  };

  # List services configure:
  services = {
    gnome = {
      games.enable = false;
      chrome-gnome-shell.enable = true;
    };
  };

  hardware = {
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vaapiIntel         
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    cpu.intel.updateMicrocode = true;
    pulseaudio.enable = false;
    bluetooth.enable = true;
  }; 
  # rtkit is optional but recommended
  security = {
    rtkit.enable = true;
    sudo.enable = false;
    doas = {
      enable = true;
      wheelNeedsPassword = true;
      extraRules = [
        { groups = [ "wheel" ]; noPass = false; keepEnv = true; persist = true; }
      ];
    };
  };

  users = {
    users.aviv = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager"];
    };
  };
  
  nix = {
    allowedUsers = [ "aviv" ];
    trustedUsers = [ "root" "aviv" ];
  };

  # List packages installed in system profile.
  environment = {
    systemPackages = with pkgs; [
      # graphic
      gimp
      # office
      libreoffice
      # customize
      gnome.gnome-tweaks
      nordic
      nordic-polar
      papirus-icon-theme
      capitaine-cursors
      # Media
      celluloid
      # FileSystemSupport
      exfat
      e2fsprogs
      f2fs-tools
      dosfstools
      hfsprogs
      jfsutils
      util-linux
      cryptsetup
      lvm2
      nilfs-utils
      ntfs3g
      udftools
      xfsprogs
      zfs
      btrfs-progs
      # SystemTools
      nano
      wget
      gparted
      # Internet
      firefox
      discord
      #gnomeExtension
      gnomeExtensions.dash-to-dock
      gnomeExtensions.dash-to-panel
      gnomeExtensions.just-perfection
      gnomeExtensions.user-themes
      gnomeExtensions.caffeine
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.panel-osd
      gnomeExtensions.topicons-plus
      gnomeExtensions.gsconnect
      gnomeExtensions.remove-dropdown-arrows
      gnomeExtensions.status-area-horizontal-spacing
    ];
  };

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
   steam.enable = true;
  };

  system.stateVersion = "21.05";

}
