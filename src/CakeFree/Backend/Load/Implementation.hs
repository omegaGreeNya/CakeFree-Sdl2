{-# LANGUAGE ScopedTypeVariables #-}
module CakeFree.Backend.Load.Implementation where

import CakeFree.Prelude

import CakeFree.Backend.Base.Classes (HasLoader(..))
import CakeFree.Backend.Base.Runtime

import qualified CakeFree.Backend.Base.Domain  as D

import Control.Exception (IOException(..))

import qualified Data.Text as T (pack)


loadResource :: HasLoader a => RuntimeCore -> D.Resource a -> IO (D.LoadResult a)
loadResource rtCore resource@(D.Location path) = do
   (eResult :: Either IOException a) <- try $ loader rtCore resource
   case eResult of
      Left err -> pure $ ([D.LoadingError (T.pack . show $ err)], blank rtCore)
      Right result -> pure $ ([], result)