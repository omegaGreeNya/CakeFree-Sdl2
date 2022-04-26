module CakeFree.Backend.Render.Language where

import CakeFree.Prelude

import CakeFree.Backend.Base.Classes (Drawable(..))

data RenderF next where
   Copy     :: Drawable a 
            => a -> next -> RenderF next
   Clear    :: next -> RenderF next
   Present  :: next -> RenderF next

instance Functor RenderF where
   fmap f (Copy    a next) = Copy    a (f next)
   fmap f (Clear     next) = Clear     (f next)
   fmap f (Present   next) = Present   (f next)

type RenderL = F RenderF

copy :: Drawable a => a -> RenderL ()
copy a = liftF $ Copy a ()

clear :: RenderL ()
clear = liftF $ Clear ()

present :: RenderL ()
present = liftF $ Clear ()
