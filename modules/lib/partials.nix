{ lib }:
{
  partialFunc = f: args1: args2: f (lib.mkMerge [ args1 args2 ]);
  partialSet = args1: args2: lib.mkMerge [ args1 args2 ];
}
