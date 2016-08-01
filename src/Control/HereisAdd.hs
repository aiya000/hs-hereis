{-# LANGUAGE ScopedTypeVariables #-}

-- | Module for app's add action
module Control.HereisAdd
  ( registerPlace
  ) where

import Control.Hereis
import Control.Monad (when)
import Control.Monad.Catch (SomeException, catch, MonadCatch, throwM)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Hereis
import Data.Map (insert, empty)
import Data.Maybe (isNothing, fromJust)
import System.Directory (createDirectoryIfMissing, getCurrentDirectory)
import System.Posix.Env (getEnv, getEnvDefault)


-- | Write current directory path as placeName to
--   child dir of $XDG_CACHE_DIR
registerPlace :: String -> IO ()
registerPlace placeName = do
  autoMkdirHereisDir
  configFilePath <- getAppConfigFilePath
  --TODO: insert to file directly
  placeMap       <- readFile' configFilePath `catch` replaceEmpty
  currentDirPath <- getCurrentDirectory
  let placeMap' = insert placeName currentDirPath placeMap
  writeFile configFilePath (show placeMap')
    where
      replaceEmpty :: SomeException -> IO PlaceMap
      replaceEmpty _ = return empty

      autoMkdirHereisDir :: IO ()
      autoMkdirHereisDir = getAppConfigDirPath
                           >>= \fp -> createDirectoryIfMissing False fp
