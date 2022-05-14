module CakeFree.Backend.Base.Classes.HasBank where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

import Data.Hashable (Hashable(..))


-- UGLY. REWORK, what about animation with many bankKeys????

-- | One a one place to store it
--   Bank is the way to load resource only once from IO
class (Eq k, Hashable k) => HasBank s configA
   | s -> configA, configA -> s where
   bankAccessor :: RuntimeCore -> ResourceBank k v
   bankKey :: (Eq k, Hashable k) => configA -> k