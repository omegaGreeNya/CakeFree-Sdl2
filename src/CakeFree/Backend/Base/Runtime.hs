module CakeFree.Backend.Base.Runtime where

import CakeFree.Prelude

import CakeFree.Backend.Base.Types.Raw.Types (Texture)

import Data.HashTable.IO (mutate)

{-

      CHANGED ME? THEN UPDATE RUNTIME.CONFIG;INITIALIZATION.IMPLEMENTATION

-}

data Blanks = Blanks
   { _texture :: Texture
   }

makeLenses ''Blanks

data LoadHandle = LoadHandle
   { _blanks :: Blanks
   }

makeLenses ''LoadHandle

data InitHandle = InitHandle
   { _loadHandle :: LoadHandle
   }
   
makeLenses ''InitHandle

data SDLVideo = SDLVideo
   { _window   :: Window
   , _renderer :: Renderer
   }

makeLenses ''SDLVideo


-- Bank == Storage (FilePath -> ResourceID)
-- Use this bad guy -> Data.HashTable.ST.Linear
type TextureBank = LinearHashTable FilePath Texture

-- In case of perfomance issues, consider Bank realisation at full scope
-- unify all banks? newtype VarHandle = VarHandle (TVar GHC.Any)?
data StateRuntime = StateRuntime
   { _textureBank :: TextureBank -- ^ Bank of all loaded textures
   }
makeLenses ''StateRuntime

data RuntimeCore = RuntimeCore
   { _initHandle :: InitHandle
   , _video      :: SDLVideo
   , _stateRuntime :: StateRuntime
   }

makeLenses ''RuntimeCore

lensWindow :: Lens' RuntimeCore Window
lensWindow = video . window

lensRenderer :: Lens' RuntimeCore Renderer
lensRenderer = video . renderer

lensBlanks :: Lens' RuntimeCore Blanks
lensBlanks = initHandle . loadHandle . blanks

-- Move away? \/

mutateTextureBank :: RuntimeCore -> FilePath -> (Maybe Texture -> (Maybe Texture, a)) -> IO a
mutateTextureBank rtCore path f = mutate (rtCore ^. stateRuntime . textureBank) path f

{- from Data.HashTable.IO
   mutate :: (Eq k, Hashable k) => h s k v -> k -> (Maybe v -> (Maybe v, a)) -> ST s a
   
   Generalized update. Given a key k, and a user function f, calls:

   `f Nothing` if the key did not exist in the hash table
   `f (Just v)` otherwise
   If the user function returns (Nothing, _), then the value is deleted from the hash table.
    Otherwise the mapping for k is inserted or replaced with the provided value.

   Returns the second part of the tuple returned by f.
-}

-- Load Texture into Bank if it wasn't already loaded
addTexture :: RuntimeCore -> FilePath -> Texture -> IO ()
addTexture rtCore path texture = mutateTextureBank rtCore path f
   where f Nothing = (Just texture, ())
         f a = (a, ())

-- Updates Loaded Texture, if it wasn' there, adds it
updateTexture :: RuntimeCore -> FilePath -> Texture -> IO ()
updateTexture rtCore path texture = mutateTextureBank rtCore path f
   where f _ = (Just texture, ())