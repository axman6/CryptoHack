#!/usr/bin/env cabal
{- cabal:
build-depends: base, cryptonite, bytestring
-}

{-# LANGUAGE TypeApplications #-}

import Crypto.Number.Serialize
import Data.ByteString (ByteString)

main = do
  print $ 
    i2osp @ByteString 11515195063862318899931685488813747395775516287289682636499965282714637259206269
