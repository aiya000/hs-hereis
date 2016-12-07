-- | The common functions and common data types
module Hereis
  ( PlaceMap
  , HereisIOException (..)
  , readFile'
  ) where

import Control.Monad ((<$!>))
import Control.Monad.Catch (Exception, MonadThrow, throwM)
import Control.Monad.Extra (ifM)
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.Either (runEitherT)
import Data.Map (Map)
import System.Directory (doesFileExist)

-- | Mapping nick name and file path
type PlaceMap = Map String FilePath

-- | Throwable IOException with the message
data HereisIOException = HereisIOException String deriving (Show)
instance Exception HereisIOException


-- | Read PlaceMap from filePath
readFile' :: (MonadThrow m, MonadIO m) => FilePath -> m PlaceMap
readFile' filePath =
  ifM (liftIO $ fmap not $ doesFileExist filePath)
    (throwM $ HereisIOException $ filePath ++ " is not exists")
    (liftIO $ fmap read $! readFile filePath)
