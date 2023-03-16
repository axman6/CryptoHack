#!/usr/bin/env cabal
{- cabal:
build-depends: base, cryptonite, bytestring
-}

{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE OverloadedStrings #-}

import Crypto.Number.Serialize
import Data.ByteString qualified as BS
import Data.ByteString (ByteString)
import Data.Bits
import Control.Monad


xorBS = BS.packZipWith xor

main = do
  let input = i2osp 0x73626960647f6b206821204f21254f7d694f7624662065622127234f726927756d
  mapM_ (\s -> when (BS.isPrefixOf "cry" s) (BS.putStr s >> putStrLn "")) $
    map  (\n -> BS.map (xor n) input) [1..255]
