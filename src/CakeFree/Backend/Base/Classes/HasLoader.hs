module CakeFree.Backend.Base.Classes.HasLoader where

import CakeFree.Prelude

import CakeFree.Backend.Base.Runtime
import CakeFree.Backend.Base.Types.Raw.Bank (Source)

import qualified CakeFree.Backend.Base.Domain as D

import Data.HashTable.IO (mutateIO)

-- Class is a bit clumzy, but whatever, if it works - fine, hide it behind interface and all good


type SourceLoader =  forall k v tabletype.
                     (HashTable tabletype, Eq k, Hashable k)
                  => RuntimeCore 
                  -> (k -> IO v)
                  -> Source k v tabletype 
                  -> IO v

-- | Class witch defines initialization of a from it's config
class HasLoader a configA | configA -> a where
   -- | Loader wich deligate loading from @Source@ type to provided function
   --   Look Texture and StaticPicture instance for usage example
   rawLoader :: RuntimeCore    -- ^ Access to subsystems like Renderer/Window
             -> SourceLoader   -- ^ function witch takes raw IO loader and Source with 'Maybe bank' and provides v w/ or w/o interaction with bank.
             -> configA        -- ^ Configuration with all paths/constatns, basicly not-initialized a
             -> IO a           -- ^ Loaded result
   -- | Return this blank in case of failed loading
   rawBlank  :: RuntimeCore -> configA -> a           
   {-# MINIMAL rawLoader, rawBlank #-}
   loader :: RuntimeCore -> SourceLoader -> D.ResourceConfig configA a -> IO a   -- ^ helper/wrapper
   loader rtCore sourceLoader (D.Config cfg) = rawLoader rtCore sourceLoader cfg
   blank :: RuntimeCore -> D.ResourceConfig configA a -> a
   blank rtCore (D.Config cfg) = rawBlank rtCore cfg

-- | Loads resource from Bank if possible, otherwise load as usual and adds resultat into bank
bankSourceLoader :: SourceLoader
bankSourceLoader _      _      (_, Nothing) = error "No bank provided"
bankSourceLoader rtCore loader (k, Just bank) = let
   modifyBankAct Nothing = do
      resource <- loader k
      return (Just resource, resource)
   modifyBankAct (Just resource) = return (Just resource, resource)
   in mutateIO bank k modifyBankAct

-- | Loads resource from IO, and place result into Bank (with overwriting)
updateSourceLoader :: SourceLoader
updateSourceLoader _      _      (_, Nothing) = error "No bank provided"
updateSourceLoader rtCore loader (k, Just bank) = let
   modifyBankAct _ = do
      result <- loader k
      return (Just result, result)
   in mutateIO bank k modifyBankAct

-- | Loads from Source and ignores bank at all
directSourceLoader :: SourceLoader
directSourceLoader _ loader (k, _) = loader k

