-- | Module for procedure of Data.Hereis
module Control.Hereis
  ( readFile'
  , getAppConfigFilePath
  , getAppConfigDirPath
  ) where

import Control.Monad ((<$!>))
import Control.Monad.Catch (MonadCatch, throwM)
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.Either (runEitherT)
import Data.Hereis
import System.Directory (doesFileExist)
import System.Posix.Env (getEnv, getEnvDefault)


-- | Detect the app's config dir path, the config dir contains config file
-- See 'getAppConfigFilePath'
getAppConfigDirPath :: (MonadCatch m, MonadIO m) => m FilePath
getAppConfigDirPath = do
  maybeHomeDir <- liftIO $ getEnv "HOME"
  case maybeHomeDir of
       Nothing      -> throwM $ IOException' "You must set $HOME"
       Just homeDir -> liftIO . fmap (++ "/hereis") $ getEnvDefault "XDG_CACHE_DIR" (homeDir ++ "/.cache")

-- | Detect the app's config file's path, the config file has serialized Data.Hereis.PlaceMap value
getAppConfigFilePath :: (MonadCatch m, MonadIO m) => m FilePath
getAppConfigFilePath = fmap (++ "/places") getAppConfigDirPath

-- | Read serialized PlaceMap value from filePath **with strictly evaluation**
readFile' :: (MonadCatch m, MonadIO m) => FilePath -> m PlaceMap
readFile' filePath = do
  b <- liftIO $ doesFileExist filePath
  if not b
    then throwM $ IOException' (filePath ++ " is not exists")
    else read' <$!> (liftIO $ readFile filePath)
  where
    read' :: String -> PlaceMap
    read' = read
