# Cloud Compute - Intel - Regular Performance
{
  boot.initrd.availableKernelModules =
    [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];

  virtualisation.hypervGuest.enable = true;
}
