module CakeFree.Backend.Lang.Interpreter where

import CakeFree.Prelude

import CakeFree.Backend.Initialisation.Interpreter

import qualified CakeFree.Backend.Lang.Language as L

langInterpretF :: L.LangF a -> IO a
langInterpretF (L.EvalInit initAct next) = do
   result <- initInterpret initAct
   return $ next result
langInterpretF (L.SafeEval scenario next) = do
   result <- try $ langInterpret scenario
   return $ next result

langInterpret :: L.LangL a -> IO a
langInterpret = foldF $ langInterpretF