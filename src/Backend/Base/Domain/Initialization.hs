module CakeFree.Backend.Base.Domain.Initialization where


{-
   Loading simple Resource from filepath (like Texture from image format, or sounds)
   And loading data from config (not implemented)
-}

newtype Resource a = ResourceLocation FilePath

type Loader a = Resource a -> LoadResult a

data LoadError = FileNotFound Text
               | NotSupportedFormat Text
               | UnknownError Text


type LoadResult a = Either LoadError a

class Loadable a where
   