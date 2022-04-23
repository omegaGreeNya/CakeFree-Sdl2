module CakeFree.Backend.Initialisation.Language where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

import qualified CakeFree.Backend.Load.Language as L


-- Move InitRuntime into AppL.
data InitialisationF next where
   InitRuntime :: RuntimeConfig
               -> (RuntimeCore -> next) -> InitialisationF next
   EvalLoad :: RuntimeCore -> L.LoadL a
            -> (a -> next) -> InitialisationF next

instance Functor InitialisationF where
   fmap f (InitRuntime cfg next) = InitRuntime cfg (f . next)
   fmap f (EvalLoad rtCore action next) = EvalLoad rtCore action (f . next)

type InitialisationL = F InitialisationF

initRuntime :: RuntimeConfig -> InitialisationL RuntimeCore
initRuntime cfg = liftF $ InitRuntime cfg id


-- window name -> init scrtipt
initRuntimeDefaultUnsafe :: Text -> InitialisationL RuntimeCore
initRuntimeDefaultUnsafe wName = initRuntime $ defaultConfigUnsafe wName

evalLoad :: RuntimeCore -> L.LoadL a -> InitialisationL a
evalLoad rtCore action = liftF $ EvalLoad rtCore action id