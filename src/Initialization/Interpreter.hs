module CakeFree.Initialization.Interpreter where


import CakeFree.Backend.Base.Initialization.Implementation

import qualified CakeFree.Backend.Base.Domain.Initialization as D
import qualified CakeFree.Initialization.Language as L


loadResourceF :: L.LoadResourceF a -> IO a
loadResourceF (LoadResource path next) = do
   result <- loadResource path
   pure $ next result


-- Runs Loading of resource
loadResource :: L.LoadResourceL a -> IO a
loadResource = foldF loadResourceF