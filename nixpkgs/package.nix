{
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "project_name";
  version = "";

  src = ./.;

  nativeBuildInputs = [
  ];

  buildInputs = [
  ];

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses;
    maintainers = with lib.maintainers; [];
  };
}
