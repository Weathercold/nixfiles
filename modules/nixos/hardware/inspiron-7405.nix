{ hw, ... }:
{
  imports = [ hw.nixosModules.dell-inspiron-7405 ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
  };

  hardware.bluetooth.enable = true;
}
