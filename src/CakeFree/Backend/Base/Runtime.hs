module CakeFree.Backend.Base.Runtime where

import CakeFree.Prelude

import CakeFree.Backend.Base.Types.Raw.Texture (Texture)

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
-- In fact, it's kind of IORef
type ResourceBank k v = LinearHashTable k v
type TextureBank = ResourceBank FilePath Texture

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

lensTextureBank :: Lens' RuntimeCore TextureBank
lensTextureBank = stateRuntime . textureBank