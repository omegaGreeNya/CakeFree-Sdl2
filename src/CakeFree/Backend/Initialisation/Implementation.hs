module CakeFree.Backend.Initialisation.Implementation where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Base.Runtime.Config

import qualified SDL

loadRtCore :: RuntimeConfig -> IO RuntimeCore
loadRtCore (RuntimeConfig wCfg rCfg blanksLoader banksCfg) = do
   window <- SDL.createWindow (_windowName wCfg) (_windowConfig wCfg)
   renderer <- SDL.createRenderer window (_rendererDriver rCfg) (_rendererConfig rCfg)
   blanks <- blanksLoader renderer
   textureBank <- (_textureBankLoader banksCfg) renderer
   return $ RuntimeCore 
            (InitHandle (LoadHandle blanks))
            (SDLVideo window renderer)
            (StateRuntime textureBank)
