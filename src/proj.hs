{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

--------------------------------------------------------------------------------

import Data.Finitary
import Data.List (intercalate, intersperse)
import GHC.Generics

--------------------------------------------------------------------------------

data Apple
  = GrannySmith
  | GoldenDelicious
  | Fuji
  deriving (Eq, Show, Generic, Finitary)

data Fruit
  = AppleFlavor Apple
  | Banana
  | Tomato
  | Kiwi
  deriving (Eq, Show, Generic, Finitary)

fruits :: [Fruit]
fruits = inhabitants

prettyFruit :: Fruit -> String
prettyFruit = \case
  AppleFlavor x -> show x
  x -> show x

main :: IO ()
main = do
  putStr "My favorite fruits are: "
  putStrLn $ intercalate ", " $ map prettyFruit fruits
