module CakeFree.Backend.Base.Types.StaticPicture where

import CakeFree.Prelude

import CakeFree.Backend.Base.Classes
import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Base.Types.Raw
import CakeFree.Backend.Base.Types.Texture

type Clip = Maybe (Rectangle CInt)
type Place = Maybe (Rectangle CInt)

-- | Good place for HKD (or even barbies)
data StaticPicture    = StaticPicture Texture Clip Place
data StaticPictureCfg = StaticPictureCfg (Source FilePath Texture) Clip Place

-- improve interface pls
defaultStaticPictureCfg :: FilePath -> StaticPictureCfg
defaultStaticPictureCfg path = StaticPictureCfg
                                 (bankSource path lensTextureBank)
                                 Nothing
                                 Nothing

instance HasLoader StaticPicture StaticPictureCfg where
   rawLoader rtCore sourceLoader (StaticPictureCfg source clip place) = do
      texture <- rawLoader rtCore sourceLoader source -- Using Texture HasLoader instance
      return (StaticPicture texture clip place)
   
   rawBlank rtCore (StaticPictureCfg _ _ place) = StaticPicture (rtCore  ^. lensBlanks . texture) Nothing place

instance Drawable StaticPicture where
   getTexture (StaticPicture (Texture texture _) _ _) = texture
   getClip    (StaticPicture _ clip _)                = clip
   getSize    (StaticPicture _ _ place)               = place