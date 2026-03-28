{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sni";
  version = "0.0.102a";

  src = fetchFromGitHub {
    owner = "alttpo";
    repo = "sni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rolm0dpn3+OnUu/OVwPdes9EM0DLZ28ksG5sDqSMKQI=";
  };

  vendorHash = "sha256-o4CShxZ8HUL2zcIEcdhr7xTjuVUIPj86zyRTYgsC6dc=";

  ldflags = [ "-s" ];

  meta = {
    description = "SNES Interface with gRPC API";
    homepage = "https://github.com/alttpo/sni";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Stenjamin ];
    mainProgram = "sni";
  };
})
