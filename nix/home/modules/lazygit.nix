{ ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        diffRenderers = [ { command = "delta --paging=never --diff-args=\"--ignore-all-space\""; } ];
        disableForcePushing = true;
      };
      gui = {
        language = "en";
        mouseEvents = false;
        sidePanelWidth = 0.3;
        mainPanelSplitMode = "flexible";
        showFileTree = false;
        nerdFontsVersion = "3";
        commitHashLength = 6;
        showDivergenceFromBaseBranch = "arrowAndNumber";
        skipRewordInEditorWarning = true;
      };
      quitOnTopLevelReturn = true;
      disableStartupPopups = true;
      promptToReturnFromSubprocess = false;
      os.editPreset = "nvim";
    };
  };
}
