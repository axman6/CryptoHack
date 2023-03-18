#!/usr/bin/env cabal
{- cabal:
build-depends: base,
               cryptonite,
               bytestring,
               network-simple,
               text,
               aeson,
               base64,
               base16
-}

{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

import Crypto.Number.Serialize
import Data.ByteString qualified as BS
import Data.ByteString.Lazy qualified as BSL
import Data.ByteString (ByteString)
import Data.Bits
import Data.Char
import Control.Monad

import Network.Simple.TCP
import Data.Text (Text)
import Data.Text qualified as T
import Data.Text.Encoding qualified as T
import Data.Text.Encoding.Base16
import Data.Text.Encoding.Base64
import Data.Aeson as A
import Control.Applicative (asum)


data Msg
  = Type Decoded
  | Flag Text
  deriving (Show, Eq)

instance FromJSON Msg where
  parseJSON = withObject "Msg" $ \o ->
    asum
      [ Flag <$> o .: "flag"
      , do
        ty :: Text <- o .: "type"
        res <- case ty of
          "base64" -> do
            enc <- o.: "encoded"
            case decodeBase64 enc of
              Left err -> fail (show err)
              Right msg -> pure msg
          "hex" -> do
            enc <- o.: "encoded"
            case decodeBase16 enc of
              Left err -> fail (show err)
              Right msg -> pure msg
          "rot13" -> do
            enc <- o.: "encoded"
            pure $ T.map rot13 enc
          "utf-8" -> do
            enc <- o.: "encoded"
            pure . T.pack $ map chr enc
          "bigint" -> do
            enc <- o.: "encoded"
            pure $ T.decodeUtf8 $ i2osp $ read enc
        pure $ Type $ Decoded res
      ]

rot :: Int -> Char -> Char
rot n c
  | isUpper c = r 'A'
  | isLower c = r 'a'
  | otherwise = c
  where
    r b = chr $ (((ord c - ord b) + n) `mod` 26) + ord b

rot13 = rot 13


newtype Decoded = Decoded { decoded :: Text }
  deriving (Show, Eq)

instance ToJSON Decoded where
  toJSON (Decoded enc) = object ["decoded" .= enc]
  toEncoding (Decoded enc) = pairs ("decoded" .= enc)

xorBS = BSL.packZipWith xor


main = do
  connect "socket.cryptohack.org" "13377" $ \(sock,addr) -> forever $ do
    recv sock 1024 >>= \case
      Nothing -> error "nothing received"
      Just bs -> do
        BS.putStr bs
        case A.eitherDecodeStrict @Msg bs of
          Left err -> error err
          Right (Flag f) -> error $ show f
          Right (Type res) -> do
            print res
            sendLazy sock (encode res)
