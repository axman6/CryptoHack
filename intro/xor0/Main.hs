#!/usr/bin/env cabal
{- cabal:
build-depends: base, cryptonite, bytestring
-}

{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE OverloadedStrings #-}

import Crypto.Number.Serialize
import Data.ByteString.Lazy qualified as BS
import Data.ByteString.Lazy (ByteString)
import Data.Bits

main = do
  print
    (BS.map (xor 13) "label" :: ByteString)
