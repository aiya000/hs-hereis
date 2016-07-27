-- | Module for app's data types
module Data.Hereis
  ( PlaceMap
  , IOException (..)
  ) where

import Data.Map (Map)
import Control.Monad.Catch (Exception)

type Message = String

-- | Hereis app's tag name and filepath mappings
type PlaceMap = Map String FilePath

-- | Re defined General Exception with Message for IO
data IOException = IOException Message deriving (Show)
instance Exception IOException
