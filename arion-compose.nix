{ pkgs, ... }:

let
  # make one vm entry, suitable for merging into the main services attrset
  mkApiVmAttrs = mode: startPort: n: {
    name = mode + builtins.toString n;
    value = mkApiVm mode (startPort + n);
  };

  # make a list of vm entries with the same mode, suitable for merging into the main services attrset
  mkApiVmAttrList = mode: startPort: nVms: map (mkApiVmAttrs mode startPort) (nixpkgs.lib.range 1 nVms);

  # make the entire services attrset
  # the start ports are arbitrary
  mkServices = cfg:
    builtins.listToAttrs (mkApiVmAttrList "guardian" cfg.guardianStartPort cfg.nGuardians) //
    builtins.listToAttrs (mkApiVmAttrList "mediator" cfg.mediatorStartPort cfg.nMediators);

in {
  config.project.name = "electionguard-web-api-test";
  services = mkServices testConfig;
}
