-- | Module for app's data types
module Data.Hereis
  ( PlaceMap
  , FileIOException (..)
  ) where

import Data.Map (Map)
import Control.Monad.Catch (Exception)

type Message = String

-- | Hereis app's tag name and filepath mappings
type PlaceMap = Map String FilePath

-- | An exception for File IO with message
data FileIOException = FileIOException Message deriving (Show)
instance Exception FileIOException
