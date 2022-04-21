module CakeFree.LoadResource.Language where

import CakeFree.Prelude

import qualified CakeFree.Backend.Base.Domain as D
import CakeFree.Backend.Base.LoadResource.Implementation (HasLoader)


data LoadResourceF next where
   LoadResource :: HasLoader a 
                => D.Resource a
                -> ((D.LoadResult a) -> next) -> LoadResourceF next

instance Functor LoadResourceF where
   fmap f (LoadResource resource next) = LoadResource resource (f . next)

type LoadResourceL = F LoadResourceF

loadResource :: HasLoader a => D.Resource a -> LoadResourceL (D.LoadResult a)
loadResource resource = liftF $ LoadResource resource id

{-
Use example (while LoadSafetly is method of LoadResourceL)

data Aboba = Aboba
   { foo :: Texture
   , bar :: Int
   , baz :: Sound
   , subAboba :: SubAboba
   }

data SubAboba = ..

loadSubAboba :: LoadResourceL (D.LoadResult SubAboba)

loadAboba :: LoadResourceL (D.LoadResult Aboba)
loadAboba =  do
   (errFoo, foo) <- loadResource Location "./data/image/Aboba.png"
   let bar = 10
   (errBaz, baz) <- loadResource Location "./data/image/Aboba.png"
   (errSubAboba, subAboba) <- loadSubAboba
   return (errFoo <> errBaz <> errSubAboba, Aboba {..})
-}