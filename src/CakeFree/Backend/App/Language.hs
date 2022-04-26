module CakeFree.Backend.App.Language where

import CakeFree.Prelude

import qualified CakeFree.Backend.Initialisation.Language as L

data AppF next where
   EvalInit :: L.InitL a -> (a -> next) -> AppF next

instance Functor AppF where
   fmap f (EvalInit initAct  next) = EvalInit initAct (f . next)

type AppL = F AppF

evalInit :: L.InitL a -> AppL a
evalInit initAct = liftF $ EvalInit initAct id
