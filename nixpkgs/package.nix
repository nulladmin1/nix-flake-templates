{
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "";
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
    maintainers = with lib.maintainers; [ ];
  };
}
