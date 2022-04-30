module CakeFree.Backend.Base.Classes.Drawable where

import CakeFree.Prelude

import qualified SDL (Texture, copy)

class Drawable a where
   getTexture :: a -> SDL.Texture
   getClip    :: a -> Maybe (Rectangle CInt)
   getSize    :: a -> Maybe (Rectangle CInt)
   {-# MINIMAL getTexture, getClip, getSize #-}
   copyDrawable :: Renderer -> a -> IO ()
   copyDrawable renderer a = 
      SDL.copy renderer (getTexture a) (getClip a) (getSize a)