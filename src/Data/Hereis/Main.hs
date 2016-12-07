-- | Module for program entry point
module Data.Hereis.Main ( app )  where

import CmdOptions
import Control.Exception (try, SomeException)
import Control.HereisAdd
import System.Console.CmdArgs (cmdArgs)

-- | Run this app
--
-- >>> app []
-- Nothing to do
--
-- >>> import System.Directory (setCurrentDirectory)
-- >>> setCurrentDirectory "/tmp"
-- >>> app ["--add", "place-name"]
-- Current directory was registered as 'place-name'
--
-- >>> setCurrentDirectory "/"
-- >>> app ["--get", "place-name"]
-- "/tmp"
--
-- >>> app ["undefined-value"]
-- Caught unknown arguments: "undefined-value"
app :: [String] -> IO ()
app [] = putStrLn "Nothing to do"

app ["--add", placeName] = do
  -- if placeName already exists, show warn message and exit
  result <- try $ registerPlace placeName
  case result of
    Left  e -> putStrLn $ "Detected the error: " ++ show (e :: SomeException)
    Right _ -> putStrLn $ "Current directory was registered as '" ++ placeName ++ "'"
app ["--get", placeName] = undefined

--TODO:
--app ["--list"] = undefined

app xs = putStrLn $ "Caught unknown arguments: " ++ show xs
