{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CakeFree.Backend.Base.LoadResource.Implementation
    ( loadResource
    , HasLoader(..)
    ) where

import CakeFree.Prelude

import qualified CakeFree.Backend.Base.Domain  as D
import CakeFree.Backend.Base.Runtime



import qualified SDL.Image as SDL (loadTexture)
import qualified Data.Text as T (pack)

import Control.Exception (IOException(..))
import System.IO (hClose, hGetLine, IOMode(..), openFile, )

loadResource :: HasLoader a => LoadHandle -> D.Resource a -> IO (D.LoadResult a)
loadResource handle resource@(D.Location path) = do
   (eResult :: Either IOException a) <- try $ loader handle resource
   case eResult of
      Left err -> pure $ ([D.LoadingError (T.pack . show $ err)], blank handle)
      Right result -> pure $ ([], result)

-- Rework?
class HasLoader a where
   rawLoader :: LoadHandle -> FilePath -> IO a
   blank :: LoadHandle -> a
   {-# MINIMAL rawLoader, blank #-}
   loader :: LoadHandle -> D.Resource a -> IO a
   loader handle = \(D.Location path) -> rawLoader handle path


-- Move into TYPES module?
instance HasLoader Texture where
   rawLoader handle = SDL.loadTexture (_renderer handle)
   blank handle = _texture . _blanks $ handle


-- test, delete after
instance HasLoader String where
   rawLoader _ path = do
      bracket (openFile path ReadMode)
             hClose
             hGetLine
   blank _ = ""
