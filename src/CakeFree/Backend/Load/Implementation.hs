{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CakeFree.Backend.Load.Implementation
    ( loadResource
    , HasLoader(..)
    ) where

import CakeFree.Prelude

import qualified CakeFree.Backend.Base.Domain  as D
import CakeFree.Backend.Base.Runtime


import Control.Exception (IOException(..))
import System.IO (hClose, hGetLine, IOMode(..), openFile, )

import qualified SDL.Image as SDL (loadTexture)
import qualified Data.Text as T (pack)


loadResource :: HasLoader a => RuntimeCore -> D.Resource a -> IO (D.LoadResult a)
loadResource rtCore resource@(D.Location path) = do
   (eResult :: Either IOException a) <- try $ loader rtCore resource
   case eResult of
      Left err -> pure $ ([D.LoadingError (T.pack . show $ err)], blank rtCore)
      Right result -> pure $ ([], result)

-- Move into TYPES module?
instance HasLoader Texture where
   rawLoader rtCore = SDL.loadTexture (rtCore ^. lensRenderer)
   blank rtCore = rtCore ^. lensBlanks . texture


-- test, delete after
instance HasLoader String where
   rawLoader _ path = do
      bracket (openFile path ReadMode)
             hClose
             hGetLine
   blank _ = ""
