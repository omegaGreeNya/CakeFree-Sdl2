module CakeFree.LoadResource.Interpreter where

import CakeFree.Prelude

import CakeFree.Backend.Base.LoadResource.Implementation
import CakeFree.Backend.Base.Runtime

import qualified CakeFree.Backend.Base.Domain  as D
import qualified CakeFree.LoadResource.Language as L

loadResourceInterpretF :: LoadHandle -> L.LoadResourceF a -> IO a
loadResourceInterpretF handle (L.LoadResource resource next) = do
   result <- loadResource handle resource
   pure $ next result

loadResourceInterpret :: LoadHandle -> L.LoadResourceL a -> IO a
loadResourceInterpret handle = foldF $ loadResourceInterpretF handle
