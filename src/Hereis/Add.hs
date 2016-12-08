{-# LANGUAGE ScopedTypeVariables #-}

-- | For adding action
module Hereis.Add
  ( registerPlace
  ) where

import Control.Monad (when)
import Control.Monad.Catch (SomeException, catch, MonadCatch, throwM)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Map (insert, empty)
import Data.Maybe (isNothing, fromJust)
import Hereis
import System.EasyFile (doesDirectoryExist, createDirectoryIfMissing)
import System.Posix.Env (getEnv, getEnvDefault)


-- | Write current directory path as placeName to
--   child dir of $XDG_CACHE_DIR
registerPlace :: String -> IO ()
registerPlace placeName = do
  configFilePath <- autoMkdirHereisDir
  --TODO: insert to file directly
  placeMap       <- readFile' configFilePath `catch` replaceEmpty
  currentDirPath <- getCurrentDirectory
  let placeMap' = insert placeName currentDirPath placeMap
  writeFile configFilePath (show placeMap')
    where
      replaceEmpty :: SomeException -> IO PlaceMap
      replaceEmpty _ = return empty

-- Detect filepath of serialized Data.Hereis.PlaceMap value,
-- and Make working directory if it's not exists.
autoMkdirHereisDir :: (MonadCatch m, MonadIO m) => m FilePath
autoMkdirHereisDir = do
  maybeHomeDir <- getEnv' "HOME"
  when (isNothing maybeHomeDir) $ do
    throwM $ HereisIOException "You must set $HOME"
  let homeDir = fromJust maybeHomeDir
  configDir <- (++ "/hereis") <$> getEnvDefault' "XDG_CACHE_DIR" (homeDir ++ "/.cache")
  createDirectoryIfMissing' False configDir
  let configFile = configDir ++ "/places"
  return configFile
    where
      getEnv' s                      = liftIO $ getEnv s
      getEnvDefault' x y             = liftIO $ getEnvDefault x y
      createDirectoryIfMissing' b fp = liftIO $ createDirectoryIfMissing b fp
