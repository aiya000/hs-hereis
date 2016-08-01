-- | Module for app's --cd action
module Control.HereisCd
  ( cdToPlace
  ) where

import Control.Hereis
import Control.Monad (when)
import Control.Monad.Catch (MonadMask, throwM)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Hereis
import System.Directory (doesDirectoryExist, setCurrentDirectory)
import qualified Data.Map as Map


cdToPlace :: (MonadMask m, MonadIO m) => PlaceName -> m ()
cdToPlace placeName = do
  configFilePath <- getAppConfigFilePath
  placeMap       <- readFile' configFilePath  -- may throw IOException
  case Map.lookup placeName placeMap of
       Nothing   -> throwM PlaceNameNotFoundException
       Just path -> cd path
    where
      cd :: (MonadMask m, MonadIO m) => FilePath -> m ()
      cd placePath = do
        b <- liftIO $ doesDirectoryExist placePath
        if not b
          then throwM $ DirectoryNotFoundException (placePath ++ " is not exists")
          else liftIO $ setCurrentDirectory placePath
