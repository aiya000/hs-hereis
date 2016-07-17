{-# LANGUAGE DeriveDataTypeable #-}

-- | Module for hereis's command line options
module CmdOptions
  ( Options (..)
  , options
  ) where

import System.Console.CmdArgs


-- | hereis options
data Options = Options
  { optCd   :: Maybe String
  , optList :: Maybe Bool
  } deriving (Show, Data, Typeable)


hereisSummary :: String
hereisSummary = "hereis is directory changing utility.\n" ++
                "You can easily bookmarking directory path for change directory.\n" ++
                "hereis [ --cd name ] [ --list ]"

-- | Options definition
options :: Options
options = Options
  { optCd   = Nothing &= explicit
           &= name "cd"
           &= help "Change directory to target name"
  , optList = False &= explicit
           &= name "list"
           &= help "Show registered name list"
  }
  &= program "hereis"
  &= summary hereisSummary
