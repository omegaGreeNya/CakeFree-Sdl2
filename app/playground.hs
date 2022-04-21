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

import CakeFree.Prelude
import CakeFree.Backend.Base.LoadResource.Implementation (HasLoader(..))
import CakeFree.LoadResource.Language
import CakeFree.LoadResource.Interpreter

import qualified BackEnd.Base.Domain as D


runPlayground :: IO ()
runPlayground = undefined
   