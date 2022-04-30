-- | Every data piece for sucessful initialisation is here

module CakeFree.Backend.Base.Runtime.Config where

import CakeFree.Prelude 

import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Base.Types

import qualified SDL (WindowConfig(..), RendererConfig(..),
                      defaultWindow, defaultRenderer)

import Data.HashTable.IO (new)

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

data BanksConfig = BanksConfig
   { _textureBankLoader :: (Renderer -> IO TextureBank)
   }

-- Renderer would use exactly _windowsCfg for initialization
data RuntimeConfig = RuntimeConfig
   { _windowCfg    :: WindowConfig
   , _rendererCfg  :: RendererConfig
   , _blanksLoader :: (Renderer -> IO Blanks)
   , _banksCfg     :: BanksConfig
   }

-- makeLenses ''RuntimeConfig

defaultWindow :: Text -> WindowConfig
defaultWindow wName = WindowConfig wName SDL.defaultWindow

defaultRenderer :: RendererConfig
defaultRenderer = RendererConfig (-1) SDL.defaultRenderer

defaultBlanksLoaderUnsafe :: Renderer -> IO Blanks
defaultBlanksLoaderUnsafe renderer = do
   (texture, size) <- loadTexture renderer "./data/blanks/texture.png"
   let _texture = Texture texture size
   return $ Blanks {..}

defaultTextureBankLoader :: Renderer -> IO TextureBank
defaultTextureBankLoader _ = new
   

defaultBanks :: BanksConfig
defaultBanks = BanksConfig defaultTextureBankLoader


-- unsafe due fixed blanks filepath, load calls action
defaultConfigUnsafe :: Text -> RuntimeConfig
defaultConfigUnsafe wName = RuntimeConfig 
   (defaultWindow wName)
   defaultRenderer
   defaultBlanksLoaderUnsafe
   defaultBanks


--- DO ME PLS
{-
lensRendererDriver :: 
lensRendererDriver 
-}