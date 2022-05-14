module CakeFree.Backend.Base.Types.Raw
   ( module X
   , Source
   , noBankSource
   , bankSource
   ) where

import CakeFree.Backend.Base.Types.Raw.Texture as X

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

-- | "Path" to the resource and maybe hashtable "pointer"
--   v is "half-phantom" i guess..
type Source k v = (k, Maybe (lens' RuntimeCore (IOHashTable tabletype k v)))

noBankSource :: k -> Source k v
noBankSource k = (k, Nothing)

bankSource :: k -> lens' RuntimeCore (IOHashTable tabletype k v) -> Source k v
bankSource k l = (k, Just l)