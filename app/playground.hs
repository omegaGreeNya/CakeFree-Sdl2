{-

1. Инициализация
2. Запуск game loop

1 Cоздает CoreRuntime
2 Работает используя данные CoreRuntime

Для начала можно опустить инициализацию (хард кодед CoreRuntime)

World - Главный стейт

Инициализация?

1. Загрузка ресурсов (звуки, картинки, уровни и всё что хочешь)
2. Сборка World
3. Инициализация окна (WindowConfig -> windowHandle)
4. Инициализация других систем.
5. Сборка CoreRuntime (со всеми ресурсами и хендлами

Game Loop?
Несущая Функция симуляции.

1. Вызвать отображение
2. Собрать инпут
3. Обработать импут (World -> Input -> World)
4. Обработать симуляцию (World -> World)
5. Повторить

-}
{-# LANGUAGE GADTs #-}

module Playground (runPlayground) 
                  where

import Control.Monad.Free.Church (liftF)


runPlayground :: IO ()
runPlayground 


-----------

data AppF next where
   EvalLang :: LangL a -> (a -> next) -> AppF next

instance Functor AppF where
   fmap f EvalLang act next = EvalLang act (f . next)

type AppL = F AppF

scenario :: LangL a -> AppL a
scenario action = liftF $ EvalLang action id

-----------

data LangF next where
   EvalRender :: RenderL a -> (a -> next) -> LangF next

instance Functor LangF where
   fmap f EvalRender action next = EvalRender action (f . next)
   
type LangL = F LangF

evalRender :: RenderL a -> LangL a
evalRender action = liftF $ EvalRender action id
-----------

data RenderF next where
   SetBG :: Colour -> (() -> next) -> RenderF next

instance Functor RenderF where
   fmap f SetBG colour next = SetBG colour (f . next)

type RenderL = F RenderF

setBG :: Colour -> RenderL
setBG colour = liftF $ SetBG colour id

-----------

type Colour = (Int, Int, Int, Int)

data CoreRuntime = CoreRuntime
   { 
   , 
   }

data AppRuntime = AppRuntime
   { _coreRuntime :: CoreRuntime
   ,
   }

-----------


interpretRenderF :: CoreRuntime -> RenderF a -> IO a
interpretRenderF coreRt (SetBG colour next) = do
   -- SDL part

runRenderL :: CoreRuntime -> RenderL a -> IO a
runRenderL coreRt = foldF (interpretRenderF coreRt)

-----------

interpretAppF :: AppRuntime -> AppF a -> IO a
interpretAppF appRt (EvalLang action next) = do
   let coreRt = _coreRuntime appRt
   res <- runLangL coreRt action
   pure $ next res

runAppL :: AppRuntime -> AppL a -> IO a
runAppL appRt = foldF (interpretAppF appRt)

-----------

interpretLangF :: AppRuntime -> LangF a -> IO a
interpretLangF coreRt (EvalRender action next) = do
   res <- runRenderL coreRt action
   pure $ next res

runLangL :: AppRuntime -> AppL a -> IO a
runLangL appRt = foldF (interpretAppF appRt)

-----------





-----------


