{ lib, attrsets }:
{
  partialFunc = f: args1: args2: f (attrsets.recursiveMerge [ args1 args2 ]);
  partialSet = args1: args2: attrsets.recursiveMerge [ args1 args2 ];
}
