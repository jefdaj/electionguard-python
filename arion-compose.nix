{ pkgs, ...}:

let
  testConfig = builtins.fromJSON (builtins.readFile ./test-config.json);

  mkApiVm = mode: port:
  {
    service.image = "electionguard/electionguard-web-api:latest";
    service.environment.API_MODE = mode;
    service.environment.PORT = port;
    service.ports  = [
      # host:container
      (builtins.toString port + ":" + builtins.toString port)
    ];
    # service.expose = [ ( builtins.toString port) ];
    # service.volumes = [ "${toString ./.}/postgres-data:/var/lib/postgresql/data" ];
  };

  # make a single-vm attrset suitable for merging into the main services attrset
  mkApiVmAttrs = mode: startPort: n: {
    name = mode + builtins.toString n;
    value = mkApiVm mode (startPort + n);
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
