module CakeFree.Backend.Initialisation.Language where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

import qualified CakeFree.Backend.Load.Language as L


-- Move InitRuntime into AppL.
data InitF next where
   InitRuntime :: RuntimeConfig
               -> (RuntimeCore -> next) -> InitF next
   EvalLoad    :: RuntimeCore -> L.LoadL a
               -> (a -> next) -> InitF next

instance Functor InitF where
   fmap f (InitRuntime cfg next) = InitRuntime cfg (f . next)
   fmap f (EvalLoad rtCore action next) = EvalLoad rtCore action (f . next)

type InitL = F InitF

initRuntime :: RuntimeConfig -> InitL RuntimeCore
initRuntime cfg = liftF $ InitRuntime cfg id


-- window name -> init scrtipt
initRuntimeDefaultUnsafe :: Text -> InitL RuntimeCore
initRuntimeDefaultUnsafe wName = initRuntime $ defaultConfigUnsafe wName

evalLoad :: RuntimeCore -> L.LoadL a -> InitL a
evalLoad rtCore action = liftF $ EvalLoad rtCore action id