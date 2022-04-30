module CakeFree.Backend.Load.Language where

import CakeFree.Prelude

import qualified CakeFree.Backend.Base.Domain as D
import CakeFree.Backend.Base.Classes (HasLoader(..))


data LoadF next where
   -- Load from Bank, or from IO with adding to the Bank
   LoadResource :: HasBank configA a, HasLoader configA a 
                => D.ResourceConfig configA a
                -> (D.LoadResult a -> next) -> LoadF next
   -- Load from IO and rewriting in the Bank
   UpdateResource :: HasBank configA a, HasLoader configA a 
                  => D.ResourceConfig configA a
                  -> (D.LoadResult a -> next) -> LoadF next
   -- Just Load from from IO, without interacting with Bank
   DirectLoadResource :: HasLoader configA a
                      => D.ResourceConfig configA a
                      -> (D.LoadResult a -> next) -> LoadF next

instance Functor LoadF where
   fmap f (LoadResource resCfg next) = LoadResource resCfg (f . next)
   fmap f (UpdateResource resCfg next) = UpdateResource resCfg (f . next)
   fmap f (DirectLoadResource resCfg next) = DirectLoadResource resCfg (f . next)

type LoadL = F LoadF

loadResource :: HasBank configA a, HasLoader configA a 
             => D.ResourceConfig configA a -> LoadL (D.LoadResult a)
loadResource resCfg = liftF $ LoadResource resCfg id

updateResource :: HasBank configA a, HasLoader configA a
               => D.ResourceConfig configA a -> LoadL (D.LoadResult a)
updateResource resCfg = liftF $ UpdateResource resCfg id

directLoadResource :: HasLoader configA a
                   => D.ResourceConfig configA a -> LoadL (D.LoadResult a)
directLoadResource resCfg = liftF $ DirectLoadResource resCfg id



{-
                                                         - TODO Update example.
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