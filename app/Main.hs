module Main where

import Data.Hereis.Main (app)
import System.Environment (getArgs)

main :: IO ()
main = getArgs >>= app
