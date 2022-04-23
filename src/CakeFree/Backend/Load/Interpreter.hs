module CakeFree.Backend.Load.Interpreter where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Load.Implementation

import qualified CakeFree.Backend.Base.Domain  as D
import qualified CakeFree.Backend.Load.Language as L

loadInterpretF :: LoadHandle -> L.LoadF a -> IO a
loadInterpretF handle (L.LoadResource resource next) = do
   result <- loadResource handle resource
   pure $ next result
loadInterpretF _ (L.SafeLoad action next) = do
   result <- try $ action
   pure $ next result

loadInterpret :: LoadHandle -> L.LoadL a -> IO a
loadInterpret handle = foldF $ loadInterpretF handle
