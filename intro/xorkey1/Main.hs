#!/usr/bin/env cabal
{- cabal:
build-depends: base, cryptonite, bytestring
-}

{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE OverloadedStrings #-}

import Crypto.Number.Serialize
import Data.ByteString qualified as BS
import Data.ByteString.Lazy qualified as BSL
import Data.ByteString (ByteString)
import Data.Bits
import Control.Monad


xorBS = BSL.packZipWith xor

main = do
  let input = BSL.fromChunks [i2osp 0x0e0b213f26041e480b26217f27342e175d0e070a3c5b103e2526217f27342e175d0e077e263451150104]
      xored = xorBS input (BSL.cycle "myXORkey")
  print xored
