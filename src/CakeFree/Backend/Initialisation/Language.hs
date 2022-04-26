module CakeFree.Backend.Initialisation.Language where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

import qualified CakeFree.Backend.Load.Language as L


-- Move InitRuntime into AppL.
data InitF next where
   InitRuntime :: RuntimeConfig
               -> (RuntimeCore -> next) -> InitF next
   

instance Functor InitF where
   fmap f (InitRuntime cfg next) = InitRuntime cfg (f . next)

type InitL = F InitF

initRuntime :: RuntimeConfig -> InitL RuntimeCore
initRuntime cfg = liftF $ InitRuntime cfg id


-- window name -> init scrtipt
initRuntimeDefaultUnsafe :: Text -> InitL RuntimeCore
initRuntimeDefaultUnsafe wName = initRuntime $ defaultConfigUnsafe wName
