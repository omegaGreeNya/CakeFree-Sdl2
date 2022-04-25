module CakeFree.Backend.Base.Runtime.Core where

import CakeFree.Prelude

data Blanks = Blanks
   { _texture :: Texture
   }

data LoadHandle = LoadHandle
   { _blanks :: Blanks
   }

data InitHandle = InitHandle
   { _loadHandle :: LoadHandle
   }
   
data SDLVideo = SDLVideo
   { _window   :: Window
   , _renderer :: Renderer
   }

data RuntimeCore = RuntimeCore
   { _initHandle :: InitHandle
   , _video      :: SDLVideo
   }