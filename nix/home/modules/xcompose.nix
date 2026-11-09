{ ... }:
{
  # The us-intl layout turns ' + c into ć; make it produce ç instead.
  home.file.".XCompose".text = ''
    include "%L"

    <dead_acute> <C> : "Ç" Ccedilla
    <dead_acute> <c> : "ç" ccedilla
  '';

  # Since GTK 4.20, dead keys need an input method unless GTK handles them itself.
  wayland.windowManager.hyprland.settings.env = [
    {
      _args = [
        "GTK_IM_MODULE"
        "simple"
      ];
    }
  ];
}
