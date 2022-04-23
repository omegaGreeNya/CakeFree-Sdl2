module CakeFree.Backend.Base.Domain.Load where

import CakeFree.Prelude

{-
   Loading simple Resource from filepath (like Texture from image format, or sounds)
   And loading data from config (not implemented)
-}

newtype Resource a = Location FilePath

data LoadError = LoadingError Text
               deriving Show

type LoadResult a = ([LoadError], a)