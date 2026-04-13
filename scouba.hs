-- Import CSV module
import Data.Csv


-- Define a data type for colors
data AnsiColor = Black | Red | Green | Yellow | Blue | Magenta | Cyan | White | Reset
    deriving (Eq, Enum, Show)


-- Map to ANSI color codes
ansi :: AnsiColor -> String
ansi Black   = "\x1b[30m"
ansi Red     = "\x1b[31m"
ansi Green   = "\x1b[32m"
ansi Yellow  = "\x1b[33m"
ansi Blue    = "\x1b[34m"
ansi Magenta = "\x1b[35m"
ansi Cyan    = "\x1b[36m"
ansi White   = "\x1b[37m"
ansi Reset   = "\x1b[0m"


-- Define data type for card suit
data Suit = Spades | Hearts | Clubs | Diamonds
    deriving (Eq, Enum, Show)

-- Define data type for card rank
data Rank = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King
    deriving (Eq, Enum, Ord, Bounded, Show)


-- Make a record for cards
data Card = Card
    { nm :: String
    , name :: String
    , suit :: Suit
    , rank :: Rank
    , value :: Int
    }


-- Function to identify face cards
isFace :: Rank -> Bool
isFace x
    | x == Jack = True
    | x == Queen = True
    | x == King = True
    | otherwise = False


-- Function to assign a color to a suit
suitColor :: Suit -> AnsiColor
suitColor x
    | x == Spades = Blue
    | x == Hearts = Red
    | x == Clubs = Cyan
    | x == Diamonds = Magenta
    | otherwise = White

-- Function to determine the display color of a card
cardColor :: Card -> AnsiColor
cardColor x = suitColor (suit x)


main :: IO ()
main = do
    putStrLn "Placeholder"
