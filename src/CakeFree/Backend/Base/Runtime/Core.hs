module CakeFree.Backend.Base.Runtime.Core where

import CakeFree.Prelude

data Blanks = Blanks
   { _texture :: Texture
   }

data LoadHandle = LoadHandle
   { _renderer :: Renderer
   , _blanks :: Blanks
   }

data InitHandle = InitHandle
   { _loadHandle :: LoadHandle
   }

data RuntimeCore = RuntimeCore
   { _initHandle :: InitHandle
   }