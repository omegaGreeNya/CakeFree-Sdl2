module CakeFree.Backend.Base.Classes.HasLoader where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

import qualified CakeFree.Backend.Base.Domain as D


-- DEFINE AND IMPORT IT
-- type Source k v = (k, Maybe (lens' RuntimeCore (IOHashTable tabletype k v)))
-- added ((k -> v) -> Source k v -> v) CONTINUE CODDING FROM THIS POINT
-- | One a one way to load it, be strict do not launchMisseles or unsafePerformIO calls
class HasLoader a configA | configA -> a where
   rawLoader :: RuntimeCore -> ((k -> v) -> Source k v -> v) -> configA -> IO a     -- ^ Load a from IO, with specified bank interaction
   rawBlank  :: RuntimeCore -> configA -> a                                         -- ^ return this blank in case of failed loading
   {-# MINIMAL rawLoader, rawBlank #-}
   loader :: RuntimeCore -> ((k -> v) -> Source k v -> v) -> D.ResourceConfig configA a -> IO a   -- ^ helper/wrapper
   loader rtCore (D.Config cfg) = rawLoader rtCore cfg
   blank :: RuntimeCore -> D.ResourceConfig configA a -> a
   blank rtCore (D.Config cfg) = rawBlank rtCore cfg