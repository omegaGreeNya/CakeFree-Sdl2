module CakeFree.Backend.Base.Types.Texture where

import CakeFree.Prelude

import CakeFree.Backend.Base.Classes
import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Base.Types.Raw.Types


import qualified SDL (Texture, surfaceDimensions,
                      createTextureFromSurface, freeSurface)
import qualified SDL.Image as SDL (load)

-- data Texture = Texture SDL.Texture Size

instance HasLoader Texture where
   rawLoader rtCore path = do
      let renderer = rtCore ^. lensRenderer
      (texture, size) <- loadTexture renderer path -- ^ from prelude
      return (Texture texture size)
   blank rtCore = rtCore ^. lensBlanks . texture

instance Drawable Texture where
   getTexture (Texture texture _) = texture
   getClip _ = Nothing
   getSize _ = Nothing