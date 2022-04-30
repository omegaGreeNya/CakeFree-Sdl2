module CakeFree.Backend.Load.Interpreter where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Load.Implementation

import qualified CakeFree.Backend.Base.Domain  as D
import qualified CakeFree.Backend.Load.Language as L

loadInterpretF :: RuntimeCore -> L.LoadF a -> IO a
loadInterpretF rtCore (L.LoadResource resCfg next) = do
   result <- loadResource rtCore resCfg
   pure $ next result
loadInterpretF rtCore (L.UpdateResource resCfg next) = do
   result <- updateResource rtCore resCfg
   pure $ next result
loadInterpretF rtCore (L.DirectLoadResource resCfg next) = do
   result <- directLoadResource rtCore resCfg
   pure $ next result

loadInterpret :: RuntimeCore -> L.LoadL a -> IO a
loadInterpret rtCore = foldF $ loadInterpretF rtCore
