{ stdenv, fetchFromGitHub, nodePackages, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-pop-shell";
  version = "2020-03-16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev = "9e8ab29cb976b078aa6e8fab59b09527a092a1b8";
    sha256 = "1za5jj95p095z4ffjli0ir3prd8fiv2bdjgjmb7h6wnni65cwfa3";
  };

  nativeBuildInputs = [
    nodePackages.typescript
    glib
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  postInstall = ''
    mkdir -p $out/share/gsettings-schemas/pop-shell-${version}/glib-2.0
    cp -R $out/share/gnome-shell/extensions/${uuid}/schemas \
          $out/share/gsettings-schemas/pop-shell-${version}/glib-2.0/schemas
  '';

  uuid = "pop-shell@system76.com";

  meta = with stdenv.lib; {
    description = "i3wm-like keyboard-driven layer for GNOME Shell";
    homepage = "https://github.com/pop-os/shell";
    license = licenses.gpl3;
    maintainers = with maintainers; [ elyhaka ];
    platforms = platforms.linux;
  };
}
