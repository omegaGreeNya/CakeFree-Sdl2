{-# LANGUAGE ScopedTypeVariables #-}
module CakeFree.Backend.Load.Implementation where

import CakeFree.Prelude

import CakeFree.Backend.Base.Classes (HasLoader(..),
                                      bankSourceLoader,
                                      updateSourceLoader,
                                      directSourceLoader,
                                      SourceLoader)
import CakeFree.Backend.Base.Runtime

import qualified CakeFree.Backend.Base.Domain  as D

import Control.Exception (IOException(..))
import Data.HashTable.IO (mutateIO)

import qualified Data.Text as T (pack)

-- first error stops loading, is there any way to collect all errors before returning blank?
-- Maybe IORef of mutable error list is the option..
-- Gonna watch some repos for solution anyway :0

genericResourceLoader :: HasLoader a configA
                   => SourceLoader
                   -> RuntimeCore
                   -> D.ResourceConfig configA a
                   -> IO (D.LoadResult a)
genericResourceLoader sourceLoader rtCore resCfg = do
   (eResult :: Either IOException a) <- try $ loader rtCore sourceLoader resCfg
   case eResult of
      Left err -> pure $ ([D.LoadingError (T.pack . show $ err)],
                          blank rtCore resCfg)
      Right result -> pure $ ([], result)

directLoadResource :: HasLoader a configA
                   => RuntimeCore
                   -> D.ResourceConfig configA a
                   -> IO (D.LoadResult a)
directLoadResource = genericResourceLoader directSourceLoader

loadResource :: HasLoader a configA
             => RuntimeCore
             -> D.ResourceConfig configA a
             -> IO (D.LoadResult a)
loadResource = genericResourceLoader bankSourceLoader
         
updateResource :: HasLoader a configA
               => RuntimeCore
               -> D.ResourceConfig configA a
               -> IO (D.LoadResult a)
updateResource = genericResourceLoader updateSourceLoader
