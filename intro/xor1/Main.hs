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


{-
KEY1 = a6c8b6733c9b22de7bc0253266a3867df55acde8635e19c73313
KEY2 ^ KEY1 = 37dcb292030faa90d07eec17e3b1c6d8daf94c35d4c9191a5e1e
KEY2 ^ KEY3 = c1545756687e7573db23aa1c3452a098b71a7fbf0fddddde5fc1
FLAG ^ KEY1 ^ KEY3 ^ KEY2 = 04ee9855208a2cd59091d04767ae47963170d1660df7f56f5faf

-}



xorBS = BS.packZipWith xor

main = do
  let key1 = i2osp 0xa6c8b6733c9b22de7bc0253266a3867df55acde8635e19c73313
      key2 = key1 `xorBS` i2osp 0x37dcb292030faa90d07eec17e3b1c6d8daf94c35d4c9191a5e1e
      key3 = key2 `xorBS` i2osp 0xc1545756687e7573db23aa1c3452a098b71a7fbf0fddddde5fc1
      flag = key1 `xorBS` key2 `xorBS` key3 `xorBS` i2osp 0x04ee9855208a2cd59091d04767ae47963170d1660df7f56f5faf
  print  flag
