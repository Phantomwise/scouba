-- ================================================================
-- IMPORTS
-- ================================================================


-- Import CSV module
import Data.Csv
-- Import module to check if files exists
import System.Directory (doesFileExist)


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
-- Not yet in use


-- ================================================================
-- CONSTANTS
-- ================================================================


-- Enable/disable debug messages
debug :: Bool
debug = True


-- Number of players
playersCount :: Int
playersCount = 2
-- Not yet in use


-- Number of cards in the hand
handSize :: Int
handSize = 5
-- Not yet in use


-- Number of cards on the table
tableSize :: Int
tableSize = 4
-- Not yet in use


-- ================================================================
-- MESSAGES
-- ================================================================


-- Print debug messages
printDebug :: String -> IO ()
printDebug msg =
    if debug
        then putStrLn (ansi Magenta ++ "[DEBUG] " ++ ansi Reset ++ msg)
        else return ()


-- Print error messages
printError :: String -> IO ()
printError msg =
    putStrLn (ansi Red ++ "[ERROR] " ++ ansi Reset ++ msg)


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
-- Not yet in use


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
-- Not yet in use


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
-- Not yet in use


-- ================================================================
-- DECK HELPERS
-- ================================================================


-- Deck File Path
deckFilePath :: FilePath
deckFilePath = "scouba_deck.csv"

-- Create Deck
createDeck :: IO String -- Change to `IO [(i,Card)` later when extraction works, or maybe `{...}` if it's a list of records? check later]
createDeck = do
    checkDeckFile deckFilePath -- IO () : succeeds or crashes
    rawDeck <- readDeckFile deckFilePath -- String <- IO String
    deck <- parseDeckFile rawDeck -- String <- IO String
    return deck -- Wraps String in IO, returns IO String

-- 1. Check Deck File
checkDeckFile :: FilePath -> IO () -- Change to `IO [(i,Card)` later when extraction works, or maybe `{...}` if it's a list of records? check later]
checkDeckFile deckFile = do
    putStrLn ("Checking for a deck file")
    deckFileExists :: Bool <- doesFileExist deckFile -- Bool <- IO Bool
    if deckFileExists == True
        then do
            printDebug ("Deck file found at " ++ deckFile) -- IO ()
        else do
            printDebug ("Deck file not found at " ++ deckFile) -- IO ()
            error "Cannot continue without deck file" -- Crashes program, never returns

-- 2. Read Deck File
readDeckFile :: FilePath -> IO String
readDeckFile deckFile = do
    rawDeck <- readFile deckFile -- String <- IO String
    printDebug ("Raw Deck: \n" ++ rawDeck) -- IO ()
    return rawDeck -- Wraps String in IO, returns IO String

-- 3. Parse Deck
parseDeckFile :: String -> IO String
parseDeckFile rawDeck = do
    let deck = "To be implemented" -- String
    return deck -- Wraps String in IO, returns IO String


{-
-- Print deck CSV file
printDeck :: IO ()
printDeck deckFile = do
    rawDeck <- 
-}

-- Ordered Deck
orderedDeck :: [(i,Card)]
orderedDeck = []
-- Not yet in use


-- Shuffled Deck
shuffledDeck :: [(i,Card)]
shuffledDeck = []
-- Not yet in use


-- Function to Shuffle Deck
-- Pretending to shuffle the deck because it's too complicated for now
shuffleDeck :: [Card] -> [Card]
shuffleDeck deck = deck
-- Not yet in use


-- Function to index the shuffled deck
indexDeck :: [Card] -> [(Int,Card)]
indexDeck deck = zip [1..] deck
-- Not yet in use


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
            _ <- createDeck -- Temporary
            return ()
            -- Later do:
            -- orderedDeck <- createDeck
            -- shuffledDeck <- shuffleDeck orderedDeck
            -- startGame shuffledDeck
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
