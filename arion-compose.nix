{ pkgs, ...}:

let
  testConfig = builtins.fromJSON (builtins.readFile ./test-config.json);

  mkApiVm = mode: n:
  let
    hostApiPort = (if mode == "guardian" then 8100 else 8200) + n;
  in {

    service.image = "electionguard/electionguard-web-api:latest";

    service.environment.API_MODE = mode;

    service.environment.PORT = hostApiPort;
    service.ports  = [
      # host:container
      (builtins.toString hostApiPort + ":" + builtins.toString hostApiPort)
    ];

    # this would expose them to other computers?
    # service.expose = [ ( builtins.toString hostApiPort) ];
    # service.expose = [];

    # service.volumes = [ "${toString ./.}/postgres-data:/var/lib/postgresql/data" ];

  };

  # make one vm entry, suitable for merging into the main services attrset
  mkApiVmAttrs = mode: startPort: n: {
    name = mode + builtins.toString n;
    value = mkApiVm mode n;
  };

  # make a list of vm entries with the same mode, suitable for merging into the main services attrset
  mkApiVmAttrList = mode: startPort: nVms: map (mkApiVmAttrs mode startPort) (pkgs.lib.range 1 nVms);

  # make the entire services attrset
  # the start ports are arbitrary
  mkServices = cfg:
    builtins.listToAttrs (mkApiVmAttrList "guardian" cfg.guardianStartPort cfg.nGuardians) //
    builtins.listToAttrs (mkApiVmAttrList "mediator" cfg.mediatorStartPort cfg.nMediators);

in {
  config.project.name = "electionguard-web-api-test";
  config.services = mkServices testConfig;
}
