{-# LANGUAGE ScopedTypeVariables #-}

--------------------------------------------------------------------------------

import Control.Applicative
import Control.Monad
import Control.Monad.Logic
import Data.Finitary
import Data.Functor.Identity
import Data.List (foldl', intercalate, intersperse)
import Data.Ord
import Data.Set qualified as Set
import Data.Word
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

{-
    Find a, b, c, d, e, f, and g, all positive integers greater than 1,
    that satisfy all equations:

    a^2 × b × c^2 × g = 5100
    a × b^2 × e × f^2 = 33462
    a × c^2 × d^3 = 17150
    a^3 × b^3 × c × d × e^2 = 914760

    ... in the fastest way possible, using your language of choice.
-}

data Guess = Guess
  { a :: !Int
  , b :: !Int
  , c :: !Int
  , d :: !Int
  , e :: !Int
  , f :: !Int
  , g :: !Int
  }
  deriving (Eq, Show, Ord)

choose :: [a] -> LogicT Identity a
choose = foldr ((<|>) . pure) empty

guesses :: Logic Guess
guesses = do
  -- TODO: do fair conjunction
  let vals = [1 .. 100]
  let e1 = 5100
      e2 = 33462
      e3 = 17150
      e4 = 914760
  a <- choose vals
  guard $ a ^ 2 < e1 && a ^ 3 < e4
  c <- choose vals
  guard $ a * c ^ 2 < e3 && a ^ 3 * c < e4
  d <- choose vals
  guard $ a * c ^ 2 * d ^ 3 == e3 && a ^ 3 * c * d < e4
  b <- choose vals
  e <- choose vals
  let exp1 = a ^ 2 * b * c ^ 2
  guard $ a ^ 3 * b ^ 3 * c * d * e ^ 2 == e4
  let g = e1 `div` exp1
  let f = e2 `div` (a * b ^ 2 * e)
  pure Guess {..}

main :: IO ()
main = do
  putStr "The fruits are: "
  putStrLn $ intercalate ", " $ map prettyFruit fruits
  print $ observe guesses
