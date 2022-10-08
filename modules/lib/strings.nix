{ lib }:
{
  # Hacky but works
  isEncrypted = str: !lib.strings.hasInfix " " str;
}
