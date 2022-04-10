module CakeFree.Backend.Base.Initialization.Implementation
    ( loadResource
    ) where

import Prelude

import qualified CakeFree.Backend.Base.Domain.Initialization as D

-- Not that ugly now, but i think there is more convinient way
loadResource :: D.Resource a -> IO (D.LoadResult a)
loadResource resource@(ResourceLocation resourcePath) = do
   let eLoader = getLoader resource
   let eResource = verifyResourceExistance resource
   let eLoadAction :: Either D.LoadError (IO a) = do
         loader <- eLoader
         resource' <- eResource
         pure $ loader resource'
   case eLoadAction of
      Left err -> pure $ Left err
      Right loadAction -> do
         eResult <- try $ loadAction
         case eResult of
            Left err -> pure $ Left UnknownError (T.pack (show err <> "{File: " <> resourcePath <> "}")
            Right result -> pure result
         

verifyResourceExistance :: D.Resource a -> Either D.LoadError (D.Resource a)
verifyResourceExistance (ResourceLocation path)@resource =
   if doesFileExist path
      then Right resource
      else Left $ FileNotFound (T.pack path)

getLoader :: D.Resource a -> Either D.LoadError (D.Resource a -> IO a)
getLoader resource = either Left (Right . wrapLoader) $ getRawLoader resource


-- Extend this case function for more resources
getRawLoader :: D.Resource a -> Either D.LoadError (FilePath -> IO a)
getRawLoader (ResourceLocation path) = 
   case tail (takeExtension path) of
      "png" -> Right $ SDL.loadPNG
      "jpg" -> Right $ SDL.loadBMP
      _     -> Left $ NotSupportedFormat (T.pack path)

wrapLoader :: (FilePath -> IO a) -> (D.Resource a -> IO a)
wrapLoader loader = \ResourceLocation path -> loader path