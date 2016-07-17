module Main where

import Test.Framework (defaultMain, testGroup)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.QuickCheck
import Test.Hspec
import Test.Hspec.QuickCheck (prop)


main :: IO ()
main = defaultMain tests

tests =
  [ testGroup "Main.app func"
    [ testProperty "prop1" prop1
    , testProperty "prop2" prop2
    ]
  ]

prop1 :: Bool -> Bool
prop1 b = True

prop2 :: Int -> Bool
prop2 i = True
