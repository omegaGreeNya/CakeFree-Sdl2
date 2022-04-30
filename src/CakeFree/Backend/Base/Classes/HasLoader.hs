module CakeFree.Backend.Base.Classes.HasLoader where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

import qualified CakeFree.Backend.Base.Domain as D

class HasLoader a where
   rawLoader :: RuntimeCore -> FilePath -> IO a
   blank :: RuntimeCore -> a
   {-# MINIMAL rawLoader, blank #-}
   loader :: RuntimeCore -> D.Resource a -> IO a
   loader rtCore = \(D.Location path) -> rawLoader rtCore path

{-
class HasLoader configA a | configA -> a, a -> configA where
   rawLoader :: RuntimeCore -> configA -> FilePath -> IO a
   blank :: RuntimeCore -> configA -> a
   {-# MINIMAL rawLoader, blank #-}
   loader :: RuntimeCore -> configA -> D.Resource a -> IO a
   loader rtCore = \(D.Location path) -> rawLoader rtCore path
-}