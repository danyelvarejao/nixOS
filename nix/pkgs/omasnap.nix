{
  cmake,
  kdePackages,
  lib,
  libdeflate,
  ninja,
  pkg-config,
  qt6,
  src,
  stdenv,
  tesseract,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wl-clipboard,
  xdg-utils,
}:
stdenv.mkDerivation {
  pname = "omasnap";
  version = src.shortRev;
  inherit src;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail /usr/share/wayland-protocols ${wayland-protocols}/share/wayland-protocols
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    wayland-scanner
  ];

  buildInputs = [
    kdePackages.layer-shell-qt
    libdeflate
    qt6.qtbase
    qt6.qtwayland
    wayland
  ];

  cmakeFlags = [ "-DBUILD_TESTING=OFF" ];

  # hyprctl comes from PATH so it always matches the running compositor.
  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        (tesseract.override {
          enableLanguages = [
            "eng"
            "por"
          ];
        })
        wl-clipboard
        xdg-utils
      ]
    }"
    "--set-default OMASNAP_OCR_LANGS por+eng"
  ];

  meta = {
    description = "Native Wayland screenshot and annotation overlay for Hyprland";
    homepage = "https://github.com/omacom/omasnap";
    license = with lib.licenses; [
      mit
      ofl
    ];
    mainProgram = "omasnap";
    platforms = lib.platforms.linux;
  };
}
