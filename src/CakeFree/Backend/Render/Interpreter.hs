module CakeFree.Backend.Render.Interpreter where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Render.Implementation

import qualified CakeFree.Backend.Render.Language as L

renderInterpretF :: RuntimeCore -> L.RenderF a -> IO a
renderInterpretF rtCore (L.Copy drawable next) = do
   result <- copy rtCore drawable
   result `seq` return next
renderInterpretF rtCore (L.Clear next) = do
   result <- clear rtCore
   result `seq` return next
renderInterpretF rtCore (L.Present next) = do
   result <- present rtCore
   result `seq` return next

renderInterpret :: RuntimeCore -> L.RenderL a -> IO a
renderInterpret rtCore = foldF $ renderInterpretF rtCore