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
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        443                           #HTTPS
        80                            #HTTP
        8080                          #HTTP Alternate
        22                            #SSH
        53                            #DNS
        1194                          #Openvpn
        27036                         #Steam ; Remote Play
        27015                         #Steam ; SRCDS Rcon port
        ];
      allowedUDPPorts = [
        443                           #HTTPS
        80                            #HTTP
        8080                          #HTTP Alternate
        22                            #SSH
        53                            #DNS
        1194                          #Openvpn
        4380                          #Steam
        27015                         #Steam : gameplay traffic
        3478                          #Steam : Steamworks P2P Networking and Steam Voice Chat
        4379                          #Steam : Steamworks P2P Networking and Steam Voice Chat
        4380                          #Steam : Steamworks P2P Networking and Steam Voice Chat
      ];
      allowedTCPPortRanges = [
        { from = 27015; to = 27030; } # Steam : To log into Steam and download content
        { from = 19302; to = 19309; } # Google : meet
        { from = 1714;  to = 1764;  } # KDE Connect
      ];
      allowedUDPPortRanges = [
        { from = 27015; to = 27030; } # Steam : To log into Steam and download content
        { from = 27000; to = 27100; } # Steam : Game traffic
        { from = 27031; to = 27036; } # Steam : Remote Play
        { from = 19302; to = 19309; } # Google : meet
        { from = 50000; to = 65535; } # Discord
      ];
    };
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
      jack.enable = true;
    };
    gnome = {
      games.enable = false;
      chrome-gnome-shell.enable = true;
    };
    tlp = {
      enable = true;
      #settings = {
      #  "SOUND_POWER_SAVE_ON_AC" = 0;
      #  "SOUND_POWER_SAVE_ON_BAT" = 1;
      #  "SOUND_POWER_SAVE_CONTROLLER" = "Y";
      #  "BAY_POWEROFF_ON_AC" = 0;
      #  "BAY_POWEROFF_ON_BAT" = 1;
      #  "DISK_APM_LEVEL_ON_AC" = "254 254";
      #  "DISK_APM_LEVEL_ON_BAT" = "128 128";
      #  "DISK_IOSCHED" = "none none";
      #  "SATA_LINKPWR_ON_AC" = "med_power_with_dipm max_performance";
      #  "SATA_LINKPWR_ON_BAT" = "min_power";
      #  "MAX_LOST_WORK_SECS_ON_AC" = 15;
      #  "MAX_LOST_WORK_SECS_ON_BAT" = 60;
      #  "NMI_WATCHDOG" = 0;
      #  "WIFI_PWR_ON_AC" = "off";
      #  "WIFI_PWR_ON_BAT" = "on";
      #  "WOL_DISABLE" = "Y";
      #  "CPU_SCALING_GOVERNOR_ON_AC" = "powersave";
      #  "CPU_SCALING_GOVERNOR_ON_BAT" = "powersave";
      #  "CPU_MIN_PERF_ON_AC" = 0;
      #  "CPU_MAX_PERF_ON_AC" = 100;
      #  "CPU_MIN_PERF_ON_BAT" = 0;
      #  "CPU_MAX_PERF_ON_BAT" = 50;
      #  "CPU_BOOST_ON_AC" = 1;
      #  "CPU_BOOST_ON_BAT" = 1;
      #  "SCHED_POWERSAVE_ON_AC" = 0;
      #  "SCHED_POWERSAVE_ON_BAT" = 1;
      #  "ENERGY_PERF_POLICY_ON_AC" = "performance";
      #  "ENERGY_PERF_POLICY_ON_BAT" = "power";
      #  "RESTORE_DEVICE_STATE_ON_STARTUP" = 0;
      #  "RUNTIME_PM_ON_AC" = "on";
      #  "RUNTIME_PM_ON_BAT" = "auto";
      #  "PCIE_ASPM_ON_AC" = "default";
      #  "PCIE_ASPM_ON_BAT" = "powersupersave";
      #  "USB_AUTOSUSPEND" = 0;
      #};
    };
    # openssh.enable = true;
    power-profiles-daemon.enable = false;
    earlyoom.enable = true;
    fstrim.enable = true;
    flatpak.enable = true;
    printing.enable = true;
  };

  hardware = {
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [
        pkgs.intel-compute-runtime
        pkgs.intel-media-driver
        pkgs.vaapiIntel         
        pkgs.vaapiVdpau
        pkgs.libvdpau-va-gl
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
        {
          groups = [ "wheel" ];
          noPass = false;
          keepEnv = true;
          persist = true; }
      ];
    };
  };

  users = {
    users.aviv = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    };
  };
  
  nix = {
    allowedUsers = [ "aviv" ];
    trustedUsers = [ "root" "aviv" ];
  };

  # List packages installed in system profile.
  environment = {
    systemPackages = with pkgs; [
      # virtualisation
      virt-manager
      
      # graphic
      gimp
      
      # office
      libreoffice
      
      # SystemTools
      nano
      wget
      gparted
      
      # Internet
      firefox
      discord
      
      # FileSystemSupport
      zfs
      lvm2
      exfat
      ntfs3g
      hfsprogs
      jfsutils
      udftools
      xfsprogs
      e2fsprogs
      f2fs-tools
      dosfstools
      util-linux
      cryptsetup
      nilfs-utils
      btrfs-progs
      
      # customize
      nordic
      nordic-polar
      capitaine-cursors
      papirus-icon-theme
      gnome.gnome-tweaks
      
      # gnomeExtension
      gnomeExtensions.caffeine
      gnomeExtensions.gsconnect
      gnomeExtensions.user-themes
      gnomeExtensions.blur-my-shell
      gnomeExtensions.just-perfection
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.status-area-horizontal-spacing
    ];
  };

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    dconf.enable = true;
   steam.enable = true;
  };

  virtualisation.libvirtd.enable = true;

  system.stateVersion = "21.05";

}
