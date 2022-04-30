module CakeFree.Backend.Base.Classes.HasBank where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

class HasBank configA a | configA -> a
   bankAccessor :: RuntimeCore -> ResourceBank k a
   bankKey :: configA -> k