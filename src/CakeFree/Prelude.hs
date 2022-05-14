module CakeFree.Prelude 
   ( module X
   , loadTexture
--   , modifyTMVar
   ) where

import SDL                       as X (Window, Renderer, Rectangle)

--import Control.Concurrent.STM    as X
import Control.Monad.Free.Church as X (F (..), foldF, liftF, fromF, iter,
                                       iterM, retract)

import Control.Exception         as X (try, bracket, Exception)
import Control.Lens              as X
import Data.HashTable.IO         as X (BasicHashTable, CuckooHashTable,
                                       LinearHashTable, IOHashTable)
import Data.Text                 as X (Text(..))
import Foreign.C.Types           as X (CInt(..))
import GHC.Prim                  as X (seq)
import Linear                    as X (V2(..))
import System.Directory          as X (doesFileExist)
import System.FilePath           as X (takeExtension)
import System.FilePath           as X (takeExtension)


--------------------------------------------------

import Control.Monad.IO.Class (MonadIO(..))

import qualified SDL (Texture, surfaceDimensions, 
                      createTextureFromSurface, freeSurface)
import qualified SDL.Image as SDL (load)

loadTexture :: MonadIO m => Renderer -> FilePath -> m (SDL.Texture, V2 CInt)
loadTexture renderer path = do
      surface <- SDL.load path
      size <- SDL.surfaceDimensions surface
      texture <- SDL.createTextureFromSurface renderer surface
      SDL.freeSurface surface
      return (texture, size)
{-
modifyTMVar :: TMVar a -> (a -> a) -> IO ()
modifyTMVar var f = atomically $ do
   v <- readTMVar var
   putTMVar var (f v)
-}