module CakeFree.Backend.Base.Types.Raw.Texture where

import CakeFree.Prelude

import qualified SDL (Texture)

type Size = V2 CInt

-- add smart-constructors?
data Texture = Texture SDL.Texture Size