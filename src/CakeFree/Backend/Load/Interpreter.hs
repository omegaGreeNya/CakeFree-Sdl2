module CakeFree.Backend.Load.Interpreter where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Load.Implementation

import qualified CakeFree.Backend.Base.Domain  as D
import qualified CakeFree.Backend.Load.Language as L

loadInterpretF :: RuntimeCore -> L.LoadF a -> IO a
loadInterpretF rtCore (L.LoadResource resource next) = do
   result <- loadResource rtCore resource
   pure $ next result

loadInterpret :: RuntimeCore -> L.LoadL a -> IO a
loadInterpret rtCore = foldF $ loadInterpretF rtCore
