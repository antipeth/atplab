{inputs, ...}: {
  imports = [
    inputs.daeuniverse.nixosModules.dae
    inputs.daeuniverse.nixosModules.daed
  ];
  services.dae = {
    enable = true;
  };
}
