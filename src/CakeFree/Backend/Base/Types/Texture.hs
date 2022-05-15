module CakeFree.Backend.Base.Types.Texture where

import CakeFree.Prelude

import CakeFree.Backend.Base.Classes
import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Base.Types.Raw

-- data Texture = Texture SDL.Texture Size
-- type Size = V2 CInt

data TextureCfg = TextureCfg (Source FilePath Texture )

instance HasLoader Texture TextureCfg where
   rawLoader rtCore sourceLoader source = do
      let renderer = rtCore ^. lensRenderer
      let loader = fmap (\(texture, size) -> Texture texture size)
                 $ loadTexture renderer -- loadTexture from prelude
      resultTexture <- sourceLoader rtCore loader source
      return resultTexture
   
   rawBlank rtCore _ = rtCore ^. lensBlanks . texture

instance Drawable Texture where
   getTexture (Texture texture _) = texture
   getClip _ = Nothing
   getSize _ = Nothing