{-# LANGUAGE ScopedTypeVariables #-}

-- | For adding action
module Hereis.Add
  ( registerPlace
  ) where

import Control.Monad.Catch (MonadCatch, MonadThrow, SomeException, throwM, try)
import Control.Monad.Extra (whenM)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Hereis
import System.EasyFile (doesDirectoryExist, createDirectoryIfMissing)
import System.Posix.Env (getEnv)
import qualified Data.Map.Lazy as Map


-- | Write directory path with its nick name to ~/.cache/hereis/places
registerPlace :: (MonadCatch m, MonadIO m) => String -> FilePath -> m ()
registerPlace placeName targetDir = do
  --TODO: Don't ignore the exception
  appDir         <- makeAppDirIfNothing
  let configFile = appDir ++ "/places"
  -- Create empty map if configFile doesn't exist
  eitherPlaceMap <- try . liftIO $ readFile configFile
  let placeMap   = case eitherPlaceMap of
                        Left  (_ :: SomeException) -> Map.empty
                        Right a -> read a
  let placeMap'  = Map.insert placeName targetDir placeMap
  liftIO $ writeFile configFile $ show placeMap'

-- |
-- Make ~/.cache/hereis directory if it doesn't exist,
-- If $HOME is not set, throw an exception
makeAppDirIfNothing :: (MonadThrow m, MonadIO m) => m FilePath
makeAppDirIfNothing = do
  mayHomeDir <- liftIO $ getEnv "HOME"
  case mayHomeDir of
    Nothing      -> throwM $ HereisIOException "You must set $HOME"
    Just homeDir -> do
      let appDir = homeDir ++ "/.cache/hereis"
      whenM (liftIO $ doesDirectoryExist appDir) $ do
        liftIO $ createDirectoryIfMissing True appDir
      return appDir
