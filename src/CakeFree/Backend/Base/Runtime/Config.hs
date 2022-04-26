-- | Every data piece for sucessful initialisation is here

module CakeFree.Backend.Base.Runtime.Config where

import CakeFree.Prelude 

import CakeFree.Backend.Base.Runtime.Core

import qualified SDL hiding (Texture, Renderer)
import qualified SDL.Image as SDL (loadTexture)

data WindowConfig = WindowConfig
   { _windowName   :: Text
   , _windowConfig :: SDL.WindowConfig
   }

-- makeLenses ''WindowConfig

data RendererConfig = RendererConfig
   { _rendererDriver :: CInt
   , _rendererConfig :: SDL.RendererConfig
   }

-- makeLenses ''RendererConfig

-- Renderer would use exactly _windowsCfg for initialization
data RuntimeConfig = RuntimeConfig
   { _windowCfg    :: WindowConfig
   , _rendererCfg  :: RendererConfig
   , _blanksLoader :: (Renderer -> IO Blanks)
   }

-- makeLenses ''RuntimeConfig

defaultWindow :: Text -> WindowConfig
defaultWindow wName = WindowConfig wName SDL.defaultWindow

defaultRenderer :: RendererConfig
defaultRenderer = RendererConfig (-1) SDL.defaultRenderer

defaultBlanksLoaderUnsafe :: Renderer -> IO Blanks
defaultBlanksLoaderUnsafe renderer = do
   _texture <- SDL.loadTexture renderer "./data/blanks/texture.png"
   return $ Blanks {..}


-- unsafe due fixed blanks filepath, load calls action
defaultConfigUnsafe :: Text -> RuntimeConfig
defaultConfigUnsafe wName = RuntimeConfig (defaultWindow wName) defaultRenderer defaultBlanksLoaderUnsafe


--- DO ME PLS
{-
lensRendererDriver :: 
lensRendererDriver 
-}