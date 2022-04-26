module CakeFree.Backend.Base.Runtime.Core where

import CakeFree.Prelude

-- CHANGE INIT IMPLEMENTATION IF YOU MODIFY THIIIIIIIS

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

data RuntimeCore = RuntimeCore
   { _initHandle :: InitHandle
   , _video      :: SDLVideo
   }

makeLenses ''RuntimeCore

lensWindow :: Lens' RuntimeCore Window
lensWindow = video . window

lensRenderer :: Lens' RuntimeCore Renderer
lensRenderer = video . renderer


lensBlanks :: Lens' RuntimeCore Blanks
lensBlanks = initHandle . loadHandle . blanks