# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

let 
  stableTarball = 
    fetchTarball 
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-20.03.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/t440p>
      <home-manager/nixos>
      ./hardware-configuration.nix
    ];

  # Allow proprietary software.
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      stable = import stableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # Allowed users for nix.
  nix.allowedUsers = [ "@wheel" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Fira Code";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    tilix
    gnumake
    wget
    unzip
    git
    git-lfs
    nodejs-10_x
    ranger
    gnome3.gnome-tweaks
    docker
    docker-compose
    home-manager
    (slack.override { nss = pkgs.nss_3_44; })
    signal-desktop
    (stable.vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        redhat.vscode-yaml
        vscodevim.vim
        ms-python.python
        scala-lang.scala
        scalameta.metals
        skyapps.fish-vscode
        bbenoist.Nix
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        ms-kubernetes-tools.vscode-kubernetes-tools
      ]
      ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "brackets-light-pro";
          publisher = "eryouhao";
          version = "0.4.3";
          sha256 = "097w1izyzigpphzm5wkf4grjkymkvkk6hhdwmbqmfqynfkcls7yy";
        }
        {
          name = "markdown-all-in-one";
          publisher = "yzhang";
          version = "3.2.0";
          sha256 = "1ww6bfyh3y90b82an4xq7xzn6jnnfmkhgfnrjqh41gpb34sn3mhk";
        }
        {
          name = "Go";
          publisher = "golang";
          version = "0.15.2";
          sha256 = "0whd0a97fd9l1rzw93r1ijr2kzmasvals9rrp5lk1j9iybxv4mf2";
        }
        {
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.128.0";
          sha256 = "1pxp38j32pf1yy00mcqxab1q0ymgxd5y7r8c9svf4dwsw0l0rfws";
        }
        {
          name = "terraform";
          publisher = "HashiCorp";
          version = "2.1.1";
          sha256 = "1l4a950sgv0jzgdax97x9gr7w5dl4gchdqf68wzwm1bykm5cznqx";
        }
      ];
    })
    (pkgs.callPackage ./pop-shell.nix {})
    cloudflared
    chromium
    google-chrome
    chrome-gnome-shell
    tmux
    fira-code
  ];

  # Environment variables (should move this in the future).
  environment.variables.EDITOR = "vim";

  # Fonts.
  fonts.fonts = with pkgs; [
    fira-code
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable WeeChat.
  services.weechat.enable = true;
  programs.screen.screenrc = "
    multiuser on 
    acladd matt
  ";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Define user accounts. Don't forget to set a password with ‘passwd’.
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
  };

  users.users.anne = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}
