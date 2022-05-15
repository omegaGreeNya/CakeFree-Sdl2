-- | Relocate this module pls

module CakeFree.Backend.Base.Types.Raw.Bank
   ( Source
   , makeSource
   ) where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

-- | "Path" to the resource and maybe hashtable "pointer"
--   uhh.. that tabletype, uglyyyyyyyyy
type Source k v tabletype = (k, Maybe (IOHashTable tabletype k v)) -- since IOHashTable is "Ref" is't okay to pass it around that way

makeSource :: HashTable tabletype => k -> Maybe (IOHashTable tabletype k v) -> Source k v tabletype
makeSource k mBank = (k, mBank)