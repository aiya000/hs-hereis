-- | Module for app's data types
module Data.Hereis
  ( PlaceMap
  , PlaceName
  , IOException' (..)
  , PlaceNameNotFoundException (..)
  , DirectoryNotFoundException (..)
  ) where

import Data.Map (Map)
import Control.Monad.Catch (Exception)

type PlaceName = String
type Message   = String

-- | Hereis app's tag name and filepath mappings
type PlaceMap = Map PlaceName FilePath

-- | Re defined General Exception with Message for IO
data IOException' = IOException' Message deriving (Show)
instance Exception IOException'

-- | If PlaceName isn't in PlaceMap, you can throw and catch this
data PlaceNameNotFoundException = PlaceNameNotFoundException deriving (Show)
instance Exception PlaceNameNotFoundException

-- | If directory isn't exists, you can throw and catch this
data DirectoryNotFoundException = DirectoryNotFoundException Message deriving (Show)
instance Exception DirectoryNotFoundException
