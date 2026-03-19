-- Import CSV module
import Data.Csv


-- Make a record for cards
data Card = Card
    { nm :: String
    , name :: String
    , suit :: Suit
    , rank :: Rank
    , value :: Int
    }


main :: IO ()
main = do
    putStrLn "Placeholder"
