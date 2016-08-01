{-# LANGUAGE ScopedTypeVariables #-}
-- | Module for main
module Main where

import Lib
import System.Console.CmdArgs (cmdArgs)
import System.Environment (getArgs)
import Control.Monad.Catch (catch, catches, SomeException, Handler(..))

type Argument = String


-- | Program's entry point
main :: IO ()
main = do
  args <- getArgs
  app args


-- |
-- Parse the argument, and to do actions
--
-- >>> app []
-- Nothing to do
-- >>> app ["place-name"]
-- registered current directory to the name 'place-name'
-- >>> app ["--cd", "place-name"]
-- changed directory to 'place-name'
-- >>> app ["undefined value"]
-- Unknowned arguments: ["undefined value"]
app :: [Argument] -> IO ()
-- If cannot get the argument
app [] = putStrLn "Nothing to do"

-- If get the option "--cd"
app ["--cd", placeName] = do
  cdToPlace placeName
    `catches`
      [ Handler catchIOException
      , Handler catchPlaceNameNotFoundException
      , Handler catchDirectoryNotFoundException
      , Handler catchOtherwise
      ]
    where
      catchIOException :: IOException' -> IO ()
      catchIOException (IOException' msg) = fail msg

      catchPlaceNameNotFoundException :: PlaceNameNotFoundException -> IO ()
      catchPlaceNameNotFoundException _ = fail $ placeName ++ " is never added by hereis"

      catchDirectoryNotFoundException :: DirectoryNotFoundException -> IO ()
      catchDirectoryNotFoundException (DirectoryNotFoundException msg) = fail msg

      catchOtherwise :: SomeException -> IO ()
      catchOtherwise e = do
          putStrLn "hereis: caught unknowed exception"
          print e

-- If get the option "--list"
app ["--list"] = undefined

-- If didn't specify option, register current directory path and name
app [placeName] = do
  -- if placeName already exists, show warn message and exit
  registerPlace placeName `catch` \(e :: SomeException) -> do
    putStr $ "adding path is failed.\n" ++
             "hereis detected an error: "
    fail $ show e
  putStrLn $ "registered current directory to the name '" ++ placeName ++ "'"

-- If get the undefined arguments
app xs = putStrLn $ "Unknowned arguments: " ++ (show xs)
