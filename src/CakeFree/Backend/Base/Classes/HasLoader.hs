module CakeFree.Backend.Base.Classes.HasLoader where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

import qualified CakeFree.Backend.Base.Domain as D

class HasLoader configA a | configA -> a where
   rawLoader :: RuntimeCore -> configA -> IO a                              -- ^ Should not interact with 'Banks'
   blank :: RuntimeCore -> configA -> a                                     -- ^ return this blank in case of failed loading
   {-# MINIMAL rawLoader, blank #-}
   loader :: RuntimeCore -> D.ResourceConfig configA a -> IO a   -- ^ helper/wrapper
   loader rtCore (D.Config cfg) = rawLoader rtCore cfg

class HasBank configA a | configA -> a
   bankAccessor :: RuntimeCore -> ResourceBank k a
   bankKey :: configA -> k