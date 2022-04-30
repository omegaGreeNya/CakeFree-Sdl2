module CakeFree.Backend.Lang.Interpreter where

import CakeFree.Prelude

import CakeFree.Backend.Load.Interpreter
import CakeFree.Backend.Render.Interpreter

import qualified CakeFree.Backend.Lang.Language as L

langInterpretF :: L.LangF a -> IO a
langInterpretF (L.EvalLoad rtCore loadAct next) = do
   result <- loadInterpret rtCore loadAct
   return $ next result
langInterpretF (L.EvalRender rtCore renderAct next) = do
   result <- renderInterpret rtCore renderAct
   return $ next result
langInterpretF (L.SafeEval scenario next) = do
   result <- try $ langInterpret scenario
   return $ next result

langInterpret :: L.LangL a -> IO a
langInterpret = foldF $ langInterpretF