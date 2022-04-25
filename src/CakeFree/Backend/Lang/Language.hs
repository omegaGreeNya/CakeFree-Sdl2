module CakeFree.Backend.Lang.Language where

import CakeFree.Prelude

import qualified CakeFree.Backend.Initialisation.Language as L

data LangF next where
   EvalInit :: L.InitL a -> (a -> next) -> LangF next
   SafeEval :: forall e a next. Exception e 
            => LangL a -> (Either e a -> next) -> LangF next

instance Functor LangF where
   fmap f (EvalInit initAct  next) = EvalInit initAct  (f . next)
   fmap f (SafeEval scenario next) = SafeEval scenario (f . next)

type LangL = F LangF

evalInit :: L.InitL a -> LangL a
evalInit initAct = liftF $ EvalInit initAct id

safeEval :: Exception e => LangL a -> LangL (Either e a)
safeEval scenario = liftF $ SafeEval scenario id