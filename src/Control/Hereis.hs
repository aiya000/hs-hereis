-- | Module for procedure of Data.Hereis
module Control.Hereis
  ( readFile'
  ) where

import Control.Monad ((<$!>))
import Control.Monad.Catch (MonadCatch, throwM)
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.Either (runEitherT)
import Data.Hereis
import System.Directory (doesFileExist)


-- | Read serialized PlaceMap value from filePath **with strictly evaluation**
readFile' :: (MonadCatch m, MonadIO m) => FilePath -> m PlaceMap
readFile' filePath = do
  b <- liftIO $ doesFileExist filePath
  if not b
    then throwM $ FileIOException (filePath ++ " is not exists")
    else read' <$!> (liftIO $ readFile filePath)
  where
    read' :: String -> PlaceMap
    read' = read
