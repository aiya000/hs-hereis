-- | Module for program entry point
module Hereis.Main ( app )  where

import Control.Monad.Catch (try, SomeException)
import Control.Monad.Trans.Either (runEitherT)
import Hereis.Add
import System.Console.CmdArgs (cmdArgs)
import System.EasyFile (getCurrentDirectory)

-- | Run this app
--
-- >>> app []
-- Nothing to do
--
-- >>> import System.EasyFile (setCurrentDirectory)
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
  currentDir <- getCurrentDirectory
  result     <- runEitherT $ registerPlace placeName currentDir
  case result of
    Left  e -> putStrLn $ "Detected the error: " ++ show (e :: SomeException)
    Right _ -> putStrLn $ "Current directory was registered as '" ++ placeName ++ "'"

app ["--get", placeName] = undefined

--TODO:
--app ["--list"] = undefined

app xs = putStrLn $ "Caught unknown arguments: " ++ show xs
