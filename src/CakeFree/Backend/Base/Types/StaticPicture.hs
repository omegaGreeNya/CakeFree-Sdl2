module CakeFree.Backend.Base.Types.StaticPicture where

import CakeFree.Prelude

import CakeFree.Backend.Base.Classes
import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Base.Types.Raw.Types
import CakeFree.Backend.Base.Types.Texture


type Clip = Maybe (Rectangle CInt)
type Place = Maybe (Rectangle CInt)

data StaticPicture = StaticPicture Texture Clip Place

instance HasLoader StaticPicture where
   rawLoader rtCore path = do
      texture <- rawLoader rtCore path    -- ^ Using texture HasLoader instance
      return (StaticPicture texture Nothing Nothing)
   blank rtCore = StaticPicture (rtCore  ^. lensBlanks . texture) Nothing Nothing

instance Drawable StaticPicture where
   getTexture (StaticPicture (Texture texture _) _ _) = texture
   getClip    (StaticPicture _ clip _)                = clip
   getSize    (StaticPicture _ _ size)                = size