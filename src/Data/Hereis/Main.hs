{-# LANGUAGE ScopedTypeVariables #-}

-- | Module for program entry point
module Data.Hereis.Main ( app )  where

import CmdOptions
import Control.Exception (catch, SomeException)
import Control.Hereis
import Control.HereisAdd
import System.Console.CmdArgs (cmdArgs)

-- | Run this app
--
-- >>> app []
-- Nothing to do
-- >>> app ["place-name"]
-- registered current directory to the name 'place-name'
-- >>> app ["--cd", "place-name"]
-- changed directory to 'place-name'
-- >>> app ["undefined value"]
-- Unknowned arguments: ["undefined value"]
app :: [String] -> IO ()
-- If cannot get the argument
app [] = putStrLn "Nothing to do"

-- If get the option "--cd"
app ["--cd", placeName] = undefined

-- If get the option "--list"
app ["--list"] = undefined

-- If didn't specify option, register current directory path and name
app [placeName] = do
  -- if placeName already exists, show warn message and exit
  registerPlace placeName `catch` \(e :: SomeException) -> do
    putStr $ "adding path is failed.\n" ++
             "hereis detected an error: "
    fail (show e)
  putStrLn $ "registered current directory to the name '" ++ placeName ++ "'"

-- If get the undefined arguments
app xs = putStrLn $ "Unknowned arguments: " ++ (show xs)
