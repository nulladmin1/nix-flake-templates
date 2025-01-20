{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  name = "project_name";

  src = fetchFromGitHub {
    owner = "Al0den";
    repo = "notion.nvim";
    rev = "a72d555da8a09ec92323181ac7f2c5c3b92658ee";
    hash = "sha256-8H+Y8xLat7XnWFMGErtkvJj1WfMAf07/qBGT7nrIG6I=";
  };
}
