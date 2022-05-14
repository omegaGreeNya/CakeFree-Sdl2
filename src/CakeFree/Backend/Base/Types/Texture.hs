module CakeFree.Backend.Base.Types.Texture where

import CakeFree.Prelude

import CakeFree.Backend.Base.Classes
import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Base.Types.Raw


import qualified SDL (Texture, surfaceDimensions,
                      createTextureFromSurface, freeSurface)
import qualified SDL.Image as SDL (load)

-- data Texture = Texture SDL.Texture Size

data TextureCfg = TextureCfg (Source FilePath Texture)

instance HasLoader Texture TextureCfg where
   rawLoader rtCore (path, _) = do
      let renderer = rtCore ^. lensRenderer
      (texture, size) <- loadTexture renderer path -- ^ from prelude
      return (Texture texture size)
   
   rawBlank rtCore _ = rtCore ^. lensBlanks . texture

instance HasBank Texture FilePath FilePath Texture where
   bankAccessor = view (stateRuntime . textureBank)
   bankKey = id

instance Drawable Texture where
   getTexture (Texture texture _) = texture
   getClip _ = Nothing
   getSize _ = Nothing