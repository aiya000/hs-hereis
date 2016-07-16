{-# LANGUAGE DeriveDataTypeable #-}

-- | Module for hereis's command line options
module CmdOptions
  ( Options (..)
  , options
  ) where

import System.Console.CmdArgs


-- | hereis options
data Options = Options
  { optCd :: Maybe String
  } deriving (Show, Data, Typeable)


hereisSummary :: String
hereisSummary = "hereis is directory changing utility.\n" ++
                "You can easily bookmarking directory path for change directory."

-- | Options definition
options :: Options
options = Options
  { optCd = Nothing &= explicit
         &= name "cd"
         &= help "change directory to target name"
  }
  &= program "hereis"
  &= summary hereisSummary
