module CakeFree.Backend.Load.Language where

import CakeFree.Prelude

import qualified CakeFree.Backend.Base.Domain as D
import CakeFree.Backend.Load.Implementation (HasLoader)


data LoadF next where
   LoadResource :: HasLoader a 
                => D.Resource a
                -> (D.LoadResult a -> next) -> LoadF next

instance Functor LoadF where
   fmap f (LoadResource resource next) = LoadResource resource (f . next)

type LoadL = F LoadF

loadResource :: HasLoader a => D.Resource a -> LoadL (D.LoadResult a)
loadResource resource = liftF $ LoadResource resource id


{-
Use example (while LoadSafetly is method of LoadL)

data Aboba = Aboba
   { foo :: Texture
   , bar :: Int
   , baz :: Sound
   , subAboba :: SubAboba
   }

data SubAboba = ..

loadSubAboba :: LoadL (D.LoadResult SubAboba)

loadAboba :: LoadL (D.LoadResult Aboba)
loadAboba =  do
   (errFoo, foo) <- loadResource Location "./data/image/Aboba.png"
   let bar = 10
   (errBaz, baz) <- loadResource Location "./data/image/Aboba.ogg"
   (errSubAboba, subAboba) <- loadSubAboba
   return (errFoo <> errBaz <> errSubAboba, Aboba {..})
-}