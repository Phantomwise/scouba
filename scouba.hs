-- ================================================================
-- IMPORTS
-- ================================================================


-- Import CSV module
import Data.Csv


-- ================================================================
-- DATA TYPES
-- ================================================================


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
{-
Should automatically create accessor functions:
    nm    :: Card -> String
    name  :: Card -> String
    suit  :: Card -> Suit
    rank  :: Card -> Rank
    value :: Card -> Int
-}


-- ================================================================
-- DEBUG
-- ================================================================


-- Enable/disable debug messages
debug :: Bool
debug = True


-- Print debug messages
printDebug :: String -> IO ()
printDebug msg =
    if debug
        then putStrLn (ansi Magenta ++ "[DEBUG] " ++ ansi Reset ++ msg)
        else return ()


-- ================================================================
-- CARD PROPERTIES HELPERS
-- ================================================================


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


-- Function to get the value of a card from its rank
rankValue :: Rank -> Int
rankValue x
    | x == Ace = 1
    | x == Two = 2
    | x == Three = 3
    | x == Four = 4
    | x == Five = 5
    | x == Six = 6
    | x == Seven = 7
    | x == Eight = 8
    | x == Nine = 9
    | x == Ten = 10
    | x == Jack = 8
    | x == Queen = 9
    | x == King = 10


-- Function to get the value of a card
cardValue :: Card -> Int
cardValue x = rankValue (rank x)


-- ================================================================
-- DECK HELPERS
-- ================================================================


-- Ordered Deck
orderedDeck :: [(i,Card)]
orderedDeck = []


-- Shuffled Deck
shuffledDeck :: [(i,Card)]
shuffledDeck = []


-- Function to Shuffle Deck
-- Pretending to shuffle the deck because it's too complicated for now
shuffleDeck :: [Card] -> [Card]
shuffleDeck deck = deck


-- Function to index the shuffled deck
indexDeck :: [Card] -> [(Int,Card)]
indexDeck deck = zip [1..] deck


-- ================================================================
-- MENU
-- ================================================================


mainMenu :: IO ()
mainMenu = do
    putStrLn "======== ======== ======== ========"
    putStrLn "             MAIN MENU"
    putStrLn "======== ======== ======== ========"
    putStrLn "n. New Game"
    putStrLn "l. New Game from deck file [DEBUG]"
    putStrLn "s. See stats"
    putStrLn "d. Reset stats"
    putStrLn "q. Quit"
    k <- getChar
    _ <- getLine
    case k of
        'n' -> do
            putStrLn "To be implemented"
            -- newGame
        'l' -> do
            putStrLn "To be implemented"
            -- loadGame
        's' -> do
            putStrLn "To be implemented"
            -- seeStats
        'd' -> do
            putStrLn "To be implemented"
            -- deleteStats
        'q' -> do
            putStrLn "Goodbye!"
        _ -> do
            mainMenu


-- ================================================================
-- MAIN
-- ================================================================


main :: IO ()
main = do
    mainMenu


-- ================================================================
