module CakeFree.Backend.Initialisation.Interpreter where

import CakeFree.Prelude

import CakeFree.Backend.Initialisation.Implementation
import CakeFree.Backend.Load.Interpreter


import qualified CakeFree.Backend.Initialisation.Language as L


initInterpretF :: L.InitF a -> IO a
initInterpretF (L.InitRuntime rtCfg next) = do
   rtCore <- loadRtCore rtCfg
   return $ next rtCore
initInterpretF (L.EvalLoad rtCore loadAct next) = do
   result <- loadInterpret rtCore loadAct
   return $ next result

initInterpret :: L.InitL a -> IO a
initInterpret = foldF $ initInterpretF