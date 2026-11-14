{ config, ... }:
{
  # Sidebar bookmarks. Home Manager owns this file, so bookmarks added from Nautilus won't stick.
  gtk.gtk3.bookmarks =
    map (dir: "file://${config.home.homeDirectory}/${dir}")
      [
        "Documents"
        "Downloads"
        "Pictures"
        "Videos"
        "Freelancers"
        "Projects"
      ];

  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      default-sort-order = "name";
      default-sort-in-reverse-order = false;
      default-folder-viewer = "list-view";
    };

    # Nautilus reads this GTK setting for hidden files.
    "org/gtk/gtk4/settings/file-chooser".show-hidden = true;
  };
}
