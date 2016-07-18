{-# LANGUAGE ScopedTypeVariables #-}

-- | Module for app's add action
module Control.HereisAdd
  ( registerPlace
  ) where

import Control.Exception (SomeException)
import Control.Hereis
import Control.Monad (when)
import Control.Monad.Catch (catch)
import Data.Hereis
import Data.Map (insert, empty)
import Data.Maybe (isNothing, fromJust)
import System.Directory (createDirectoryIfMissing, getCurrentDirectory)
import System.Posix.Env (getEnv, getEnvDefault)


-- | Write current directory path as placeName to
--   child dir of $XDG_CACHE_DIR
registerPlace :: String -> IO ()
registerPlace placeName = do
  configFilePath <- autoMkdirHereisDir
  --TODO: insert to file directly
  placeMap       <- readFile' configFilePath `catch` \(_ :: SomeException) -> return empty
  currentDirPath <- getCurrentDirectory
  let placeMap' = insert placeName currentDirPath placeMap
  writeFile configFilePath (show placeMap')

-- Detect filepath of serialized Data.Hereis.PlaceMap value,
-- and Make working directory if it's not exists.
autoMkdirHereisDir :: IO FilePath
autoMkdirHereisDir = do
  maybeHomeDir <- getEnv "HOME"
  when (isNothing maybeHomeDir) $ do
    fail "You must set $HOME"
  let homeDir = fromJust maybeHomeDir
  configDir <- (++ "/hereis") <$> getEnvDefault "XDG_CACHE_DIR" (homeDir ++ "/.cache")
  createDirectoryIfMissing False configDir
  let configFile = configDir ++ "/places"
  return configFile
