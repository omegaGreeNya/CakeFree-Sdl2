{-
Забракованные подходы
-}
{-
1. Использовать Два языка для загрузки UnsafeLoadResourceL и LoadResourceL.
   Планировалось писать сцернарии загрузки через Unsafe язык и с помощью
   очень умных функций, переводить их в safe:
   loadSafetly :: UnsafeLoadResourceL a -> LoadResourceL (LoadResult a)
   Но, из-за смены и возвращаемого типа (a -> Either [LoadError] a)
   Сложно переделать старый сценарий, под новый функтор и язык.
   Даже если получится собрать loadSafetly, изменения подхода к загрузке
   потребуют изменения loadSafetly, что может быть сложным.

   Предполагаемое использование в бизнес логике:

data Aboba = Aboba
   { foo :: Texture
   , bar :: Int
   , baz :: Sound
   }

loadAboba :: UnsafeLoadResourceL (D.LoadResult Aboba)
loadAboba = loadSafetly loadAboba'

loadAboba' :: UnsafeLoadResourceL Aboba
loadAboba' =  do
   foo <- loadResource "./data/image/Aboba.png"
   let bar = 10
   baz <- loadResource "./data/sound/Aboba.ogg"
   return $ Aboba {..}
   
   Забракованный код:
-}
data UnsafeLoadResourceF next where
   UnsafeLoadResource :: HasLoader a
                      => Resource a
                      -> (a -> next) -> UnsafeLoadResourceF next

instance Functor UnsafeLoadResourceF where
   fmap f (UnsafeLoadResource resource next) = UnsafeLoadResource resource (f . next)

type UnsafeLoadResourceL = F UnsafeLoadResourceF

loadResource :: HasLoader a => Resource a -> UnsafeLoadResourceL a
loadResource resource = liftF $ UnsafeLoadResource resource id

data LoadResourceF next where
   LoadResource :: HasLoader a
                => ([LoadError], Resource a)
                -> (LoadResult a -> next) -> LoadResourceF next


instance Functor LoadResourceF where
   fmap f (LoadResource resource next) = LoadResource resource (f . next)

type LoadResourceL = F LoadResourceF

loadSafetlyF :: UnsafeLoadResourceF a -> LoadResourceF (LoadResult a)
loadSafetlyF (UnsafeLoadResource resource next) =
   LoadResource ([], resource) next'
   where
      next' (Left errors) = Left errors -- Должен ли я тут вызывать next, если мне нечего ему передать.. Допустим, нет
      next' (Right result) = Right . next $ result

-- Функция с ошибкой
loadSafetly :: UnsafeLoadResourceL a -> LoadResourceL (LoadResult a)
loadSafetly (F m) = F (\p f -> m (p . Right) (f . loadSafetlyF))

{-
f :: LoadResourceF r -> r
  
p :: LoadResult a -> r
  
m :: forall r. (a -> r) -> (UnsafeLoadResourceF r -> r) -> r
-}

interpretLoadResourceF :: HasLoader a
                       => LoadResourceF a -> IO a
interpretLoadResourceF (LoadResource ([], resource) next) = do
   eResult <- loadResource' resource -- From implementation
   case eResult of
      Left newErrors -> pure . next . Left $ newErrors
      result   -> pure . next $ result
interpretLoadResourceF (LoadResource (errors, resource) next) = do
   eResult <- loadResource' resource
   case eResult of
      Left newErrors -> pure . next . Left $ errors <> newErrors
      result   -> pure . next $ result

loadSafetly' :: HasLoader a
             => LoadResourceL a -> IO a
loadSafetly' = foldF $ interpretLoadResourceF

loadResource' = undefined

{-
   2. 
-}
