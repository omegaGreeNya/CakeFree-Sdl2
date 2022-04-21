module CakeFree.Backend.Base.Runtime where

import CakeFree.Prelude

data Blanks = Blanks
   { _texture :: Texture
   }

data LoadHandle = LoadHandle
   { _renderer :: Renderer
   , _blanks :: Blanks
   }
