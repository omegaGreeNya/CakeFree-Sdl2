{-# LANGUAGE ScopedTypeVariables #-}
module CakeFree.Backend.Load.Implementation where

import CakeFree.Prelude

import CakeFree.Backend.Base.Classes (HasLoader(..), HasBank(..))
import CakeFree.Backend.Base.Runtime

import qualified CakeFree.Backend.Base.Domain  as D

import Control.Exception (IOException(..))
import Data.HashTable.IO (mutateIO)

import qualified Data.Text as T (pack)


directLoadResource :: HasLoader a configA
                   => RuntimeCore
                   -> D.ResourceConfig configA a
                   -> IO (D.LoadResult a)
directLoadResource rtCore resCfg = do
   (eResult :: Either IOException a) <- try $ loader rtCore resCfg
   case eResult of
      Left err -> pure $ ([D.LoadingError (T.pack . show $ err)],
                          blank rtCore resCfg)
      Right result -> pure $ ([], result)

loadWithBank :: (HasBank a configA k v, HasLoader a configA)
             => (Maybe a -> IO (Maybe a, D.LoadResult a))      -- ^ ('Resource by key' -> IO ('New Resource by key (Nothing = delete)', 'Final Result')
             -> RuntimeCore
             -> D.ResourceConfig configA a
             -> IO (D.LoadResult a)
loadWithBank modifyBankAct rtCore (D.Config cfg) = do
   let key = bankKey cfg
   let bank = bankAccessor rtCore
   mutateIO bank key modifyBankAct

loadResource :: (HasBank a configA k v, HasLoader a configA)
             => RuntimeCore
             -> D.ResourceConfig configA a
             -> IO (D.LoadResult a)
loadResource rtCore resCfg = let
   modifyBankAct Nothing = do
      result@(_, resource) <- directLoadResource rtCore resCfg
      return (Just resource, result)
   modifyBankAct (Just resource) = return (Just resource, ([], resource))
   in loadWithBank modifyBankAct rtCore resCfg
         
updateResource :: (HasBank a configA k v, HasLoader a configA)
               => RuntimeCore
               -> D.ResourceConfig configA a
               -> IO (D.LoadResult a)
updateResource rtCore resCfg = let
   modifyBankAct _ = do
      result@(_, resource) <- directLoadResource rtCore resCfg
      return (Just resource, result)
   in loadWithBank modifyBankAct rtCore resCfg
