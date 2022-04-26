module CakeFree.Backend.App.Interpreter where

import CakeFree.Prelude

import CakeFree.Backend.Initialisation.Interpreter

import qualified CakeFree.Backend.App.Language as L

appInterpretF :: L.AppF a -> IO a
appInterpretF (L.EvalInit initAct next) = do
   result <- initInterpret initAct
   return $ next result

appInterpret :: L.AppL a -> IO a
appInterpret = foldF $ appInterpretF