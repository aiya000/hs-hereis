module Main where

import Hereis.Main (app)
import System.Environment (getArgs)

main :: IO ()
main = getArgs >>= app
