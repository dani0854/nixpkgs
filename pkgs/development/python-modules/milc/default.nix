{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  argcomplete,
  colorama,
  halo,
  platformdirs,
  spinners,
  types-colorama,
  typing-extensions,
  setuptools,
  nose2,
  semver,
}:

buildPythonPackage rec {
  pname = "milc";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clueboard";
    repo = "milc";
    rev = version;
    hash = "sha256-byj2mcDxLl7rZEFjAt/g1kHllnVxiTIQaTMG24GeSVc=";
  };

  postPatch = ''
    # Needed for tests
    patchShebangs --build \
      example \
      custom_logger \
      questions \
      sparkline \
      hello \
      passwd_confirm \
      passwd_complexity \
      config_source
  '';

  dependencies = [
    argcomplete
    colorama
    halo
    platformdirs
    spinners
    types-colorama
    typing-extensions
  ];

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    nose2
    semver
  ];

  checkPhase = ''
    runHook preCheck

    # Run tests
    nose2 -v

    runHook postCheck
  '';

  pythonImportsCheck = [ "milc" ];

  meta = with lib; {
    description = "Opinionated Batteries-Included Python 3 CLI Framework";
    mainProgram = "milc-color";
    homepage = "https://milc.clueboard.co";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
