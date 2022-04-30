module CakeFree.Backend.Lang.Language where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime

import qualified CakeFree.Backend.Load.Language as L
import qualified CakeFree.Backend.Render.Language as L

data LangF next where
   EvalLoad   :: RuntimeCore -> L.LoadL a
              -> (a -> next) -> LangF next
   EvalRender :: RuntimeCore -> L.RenderL a
              -> (a -> next) -> LangF next
   SafeEval   :: forall e a next. Exception e 
              => LangL a -> (Either e a -> next) -> LangF next

instance Functor LangF where
   fmap f (EvalLoad rtCore action next) = EvalLoad rtCore action (f . next)
   fmap f (EvalRender rtCore action next) = EvalRender rtCore action (f . next)
   fmap f (SafeEval scenario next) = SafeEval scenario (f . next)

type LangL = F LangF


evalLoad :: RuntimeCore -> L.LoadL a -> LangL a
evalLoad rtCore action = liftF $ EvalLoad rtCore action id

evalRender :: RuntimeCore -> L.RenderL a -> LangL a
evalRender rtCore action = liftF $ EvalRender rtCore action id

safeEval :: Exception e => LangL a -> LangL (Either e a)
safeEval scenario = liftF $ SafeEval scenario id
