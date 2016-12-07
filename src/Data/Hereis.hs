-- | The procedure
module Data.Hereis
  ( PlaceMap
  , IOException (..)
  , readFile'
  ) where

import Control.Monad ((<$!>))
import Control.Monad.Catch (Exception, MonadCatch, throwM)
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.Either (runEitherT)
import Data.Map (Map)
import System.Directory (doesFileExist)

type Message = String

-- | Hereis app's tag name and filepath mappings
type PlaceMap = Map String FilePath

-- | Re defined General Exception with Message for IO
data IOException = IOException Message deriving (Show)
instance Exception IOException


-- | Read serialized PlaceMap value from filePath **with strictly evaluation**
readFile' :: (MonadCatch m, MonadIO m) => FilePath -> m PlaceMap
readFile' filePath = do
  b <- liftIO $ doesFileExist filePath
  if not b
    then throwM $ IOException (filePath ++ " is not exists")
    else read' <$!> (liftIO $ readFile filePath)
  where
    read' :: String -> PlaceMap
    read' = read
