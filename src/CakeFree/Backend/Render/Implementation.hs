module CakeFree.Backend.Render.Implementation where

import CakeFree.Prelude

import CakeFree.Backend.Base.Classes (Drawable(..))
import CakeFree.Backend.Base.Runtime

import qualified SDL (clear, present)

copy :: Drawable a => RuntimeCore -> a -> IO ()
copy rtCore = copyDrawable (rtCore ^. lensRenderer)

clear :: RuntimeCore -> IO ()
clear rtCore = SDL.clear (rtCore ^. lensRenderer)

present :: RuntimeCore -> IO ()
present rtCore = SDL.present (rtCore ^. lensRenderer)