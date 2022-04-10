module CakeFree.Initialization.Language where

{- 
   First attempt is full fail, im gonna upload current state on git hub and rework this lang
-}
import Prelude

import qualified Backend.Base.Domain.Initialization as D


data LoadResourceF next where
   LoadResource :: D.Resource a
                -> (D.LoadResult a -> next)
                -> LoadResourceF next

instance Fuctore LoadResourceF where
   fmap f (LoadResource resource next) =  LoadResource resource loader (f . next)

type LoadResourceL = F LoadResourceF

loadResource :: D.Resource a -> LoadResourceL (D.LoadResult a)
loadResource resource = liftF $ LoadResource resource id

class Loadable s where
   tryLoad :: LoadResourseL (Either [D.LoadError] s)
{-

Probably I should decouple errors and loading (read error handling again)

loadStructure :: sT -> LoadResourceL (Either [LoadError] s)
loadStructure = some generic function for automatic transforming St to S
Not implemented // Need to heavy smoke GHC.Generic

So, for now construct loading scenario by hands like so
WARNING: TIDEOUS AND ERROR-PRONE, you really want to make it in Generic way (please)
Really bad design
<<<<

data State = State
   { _image :: Texture
   , _coolNumber :: Int
   , _subState :: SubState
   }

data SubState = ..

instance Laodable SubState where
   tryLoad = ..

instance Loadable State where
   tryLoad = do
      eImage <- loadResource "./data/images/img1.png"
      let _coolNumber = 10
      eSubState <- tryLoad
      let errorList = catMaybes [maybeLeft eImage, maybeLeft eSubState]
      if not.null $ errorList
         then return $ Left errorList
         else do
            let _image = fromRight eImage
            let _subState = fromRight eSubState
            return State {..}

loadFirstState :: LoadResourceF (Either [LoadError] State)
loadFirstState = do
   _image <- loadResource "./data/images/img1.png"
   let _coolNumber = 10
   

-- from prelude
maybeLeft :: Either a b -> Maybe a
maybeLeft (Left a) = Just a
maybeLeft _        = Nothing

collectErrors :: [Maybe a] -> [a]
collectErrors 

>>>>




data AbobaT = AbobaT
   { foo :: Resource Texture
   , bar :: Int
   }

abobaT = AbobaT "./data/aboba.png" 10

data Aboba = Aboba
   { foo :: Texture
   , bar :: Int
   }

loadStructure (undefined :: AbobaT) :: Either [LoadError] Aboba

-}