module CakeFree.Backend.Base.Classes.HasLoader where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

class HasLoader a where
   rawLoader :: RuntimeCore -> FilePath -> IO a
   blank :: RuntimeCore -> a
   {-# MINIMAL rawLoader, blank #-}
   loader :: RuntimeCore -> D.Resource a -> IO a
   loader rtCore = \(D.Location path) -> rawLoader rtCore path