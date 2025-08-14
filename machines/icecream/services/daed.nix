{inputs, ...}: {
  imports = [
    inputs.daeuniverse.nixosModules.dae
    inputs.daeuniverse.nixosModules.daed
  ];
  services.daed = {
    enable = true;
    listen = "0.0.0.0:2023";
  };
}
