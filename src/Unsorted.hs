-- ================================================================
-- HEADER
-- ================================================================


module Unsorted where


-- ================================================================
-- IMPORTS
-- ================================================================


import System.Directory (doesFileExist)
-- Needed to check if files exist
-- base

import System.Exit (ExitCode(..), exitWith, exitSuccess)
-- Needed to exit cleanly with an exit code
-- base

import Data.Csv
-- Cassava module
-- Needed to parse CSV data
-- haskellPackages.cassava
-- Not yet in use
-- TODO: REMOVE

import qualified Data.ByteString.Lazy as BL
-- Needed by cassava to read CSV
-- TODO: find out what the hell lazy bytestrings are
-- TODO: REMOVE

import qualified Data.ByteString.Lazy.Char8 as BLC
-- Needed by BLC.unpack to convert a ByteString into a String
-- TODO: REMOVE

import qualified Data.ByteString.Char8 as B8
-- Needed to implement manual parsing and preserve my sanity from Cassava
-- Char8 allows using `,` and `\n` instead of the byte sequences `44` and `10`


-- ================================================================
-- CONFIGURATION
-- ================================================================


-- Enable/disable debug messages
debug :: Bool
debug = True


-- Deck File Path
deckFilePath :: FilePath
deckFilePath = "scouba_deck.csv"


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
-- COLOR AND DISPLAY
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
-- EXIT HANDLING
-- ================================================================


-- Define a data type for exit statuses
data ExitStatus
    = Success
    | GeneralError
    | FileNotFound FilePath
    | ParseError
    | UnknownError
    deriving (Show, Eq)

-- Map ExitStatus to Exit Codes
statusCode :: ExitStatus -> IO ()
statusCode  Success         = exitWith (ExitSuccess) -- Not using exitSuccess because aligned code makes me happy
statusCode  GeneralError    = exitWith (ExitFailure 1)
statusCode (FileNotFound _) = exitWith (ExitFailure 2)
statusCode  ParseError      = exitWith (ExitFailure 3)
statusCode  UnknownError    = exitWith (ExitFailure 9)

-- Print an exit message
exitMessage :: ExitStatus -> String
exitMessage  Success            = ("Exiting")
exitMessage  GeneralError       = ("General error")
exitMessage (FileNotFound path) = ("File not found: " ++ path)
exitMessage  ParseError         = ("Parsing error")
exitMessage  UnknownError       = ("Unknown error")

-- Exit with specific status
exitGame :: ExitStatus -> IO ()
exitGame Success = do
    putStrLn (exitMessage Success)
    statusCode UnknownError
exitGame status = do
    printError (exitMessage status)
    statusCode UnknownError
-- Not yet in use


-- ================================================================
-- CARDS
-- ================================================================


-- Define data type for card suit
data Suit = Spades | Hearts | Clubs | Diamonds
    deriving (Eq, Enum, Show)


-- Define data type for card rank
data Rank = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King
    deriving (Eq, Enum, Ord, Bounded, Show)

-- Make a record for cards
data Card = Card
    { nm :: !String
    , name :: !String
    , suit :: !Suit
    , rank :: !Rank
    , value :: !Int
    }
    deriving (Eq, Show)

{-
Should automatically create accessor functions:
    nm    :: Card -> String
    name  :: Card -> String
    suit  :: Card -> Suit
    rank  :: Card -> Rank
    value :: Card -> Int
-}
-- Not yet in use


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

-- Create Deck
createDeck :: IO (Either String [Card]) -- Change to `IO [(i,Card)]` later when extraction and shuffling works]
createDeck = do
    checkDeckFile deckFilePath -- IO () : succeeds or crashes
    deckB8                  :: B8.ByteString        <- readDeckFileBytestring deckFilePath  -- B8.ByteString <- IO B8.ByteString
    printDebug ("ByteString Deck: (putStrLn show)")                                         -- IO ()
    putStrLn (show deckB8)                                                                  -- IO ()
    printDebug ("ByteString Deck: (B8.putStrLn)")                                           -- IO ()
    B8.putStrLn (deckB8)                                                                    -- IO ()
    let deckB8List          :: [[B8.ByteString]]    = parseDeckFileManualB8 deckB8          -- B8.ByteString <- [[B8.ByteString]]
    printDebug ("ByteString Deck parsed as a List of Lists:")                               -- IO ()
    putStrLn (show deckB8List)                                                              -- IO ()
    let deckB8ListFiltered  :: [[B8.ByteString]]    = filterDeckEmptyRows deckB8List
    printDebug ("ByteString Deck with empty rows filtered out:")                            -- IO ()
    putStrLn (show deckB8ListFiltered)                                                      -- IO ()
    let deckB8DropHeader    :: [[B8.ByteString]]    = drop 1 deckB8ListFiltered
    printDebug ("ByteString Deck with empty rows filtered out and row 1 dropped:")          -- IO ()
    putStrLn (show deckB8DropHeader)                                                        -- IO ()
    let deckB8Final         :: [[B8.ByteString]]    = deckB8DropHeader
    putStrLn (show deckB8Final)                                                             -- IO ()
    let deckFinal           :: Either String [Card] = parseDeckToListOfCards deckB8Final
    printDebug ("Card Deck:")                                                               -- IO ()
    putStrLn (show deckFinal)                                                               -- IO ()
    return deckFinal                                                                        -- Wraps String in IO, returns IO String

-- 1. Check Deck File
checkDeckFile :: FilePath -> IO ()
checkDeckFile deckFile = do
    putStrLn ("Checking for a deck file")
    deckFileExists :: Bool <- doesFileExist deckFile -- Bool <- IO Bool
    if deckFileExists == True
        then do
            printDebug ("Deck file found at " ++ deckFile) -- IO ()
        else do
            printDebug ("Deck file not found at " ++ deckFile) -- IO ()
            exitGame (FileNotFound deckFile)

-- 2. Read Deck File (Strict ByteString)
readDeckFileBytestring :: FilePath -> IO B8.ByteString
readDeckFileBytestring deckFile = do
    deckB8 <- B8.readFile deckFile -- B8.ByteString <- IO B8.ByteString
    printDebug ("ByteString Deck:") -- IO ()
    putStrLn (show deckB8) -- IO ()
    return deckB8 -- Wraps String in IO, returns IO String

-- 3. Parse Deck as strict ByteString without Cassava
parseDeckFileManualB8 :: B8.ByteString -> [[B8.ByteString]]
parseDeckFileManualB8 deckRaw = map (B8.split ',') (B8.split '\n' deckRaw)

-- 4. Filter out empty rows
filterDeckEmptyRows :: [[B8.ByteString]] -> [[B8.ByteString]]
filterDeckEmptyRows xs = [x | x <- xs, not (null x)]


-- Parse full deck
parseDeckToListOfCards :: [[B8.ByteString]] -> Either String [Card]
parseDeckToListOfCards d = mapM parseRowToCard d

-- Parse deck row
parseRowToCard :: [B8.ByteString] -> Either String Card
parseRowToCard [nm, name, suit, rank, value] =
    case parseNm nm of
        Left err -> Left ("Parsing error on " ++ err)
        Right n ->
            case parseName name of
                Left err -> Left ("Parsing error on " ++ err)
                Right na ->
                    case parseSuit suit of
                        Left err -> Left ("Parsing error on " ++ err)
                        Right s ->
                            case parseRank rank of
                                Left err -> Left ("Parsing error on " ++ err)
                                Right r ->
                                    case parseValue value of
                                        Left err -> Left ("Parsing error on " ++ err)
                                        Right v -> Right (Card { nm = n, name = na, suit = s, rank = r, value = v } )

-- Parse Nm field
parseNm :: B8.ByteString -> Either String String -- Change it to Either String Text later
parseNm bs
    | s == "" = Left ("Invalid Nm field:" ++ B8.unpack bs)
    | otherwise = Right s
    where s = B8.unpack bs

-- Parse Name field
parseName :: B8.ByteString -> Either String String -- Change it to Either String Text later
parseName bs
    | s == "" = Left ("Invalid Name field:" ++ B8.unpack bs)
    | otherwise = Right s
    where s = B8.unpack bs

-- Parse Value field
parseValue :: B8.ByteString -> Either String Int
parseValue bs =
    case reads (B8.unpack bs) :: [(Int, String)] of
        [(n,"")] -> Right n
        _        -> Left ("Invalid Value field:" ++ B8.unpack bs)

-- Parse Suit field
parseSuit :: B8.ByteString -> Either String Suit
parseSuit bs
    | bs == B8.pack "Spades"   = Right Spades
    | bs == B8.pack "Hearts"   = Right Hearts
    | bs == B8.pack "Clubs"    = Right Clubs
    | bs == B8.pack "Diamonds" = Right Diamonds
    | otherwise                = Left ("Invalid suit:" ++ B8.unpack bs)

-- Parse Rank field
parseRank :: B8.ByteString -> Either String Rank
parseRank bs
    | bs == B8.pack "Ace"   = Right Ace
    | bs == B8.pack "Two"   = Right Two
    | bs == B8.pack "Three" = Right Three
    | bs == B8.pack "Four"  = Right Four
    | bs == B8.pack "Five"  = Right Five
    | bs == B8.pack "Six"   = Right Six
    | bs == B8.pack "Seven" = Right Seven
    | bs == B8.pack "Eight" = Right Eight
    | bs == B8.pack "Nine"  = Right Nine
    | bs == B8.pack "Ten"   = Right Ten
    | bs == B8.pack "Jack"  = Right Jack
    | bs == B8.pack "Queen" = Right Queen
    | bs == B8.pack "King"  = Right King
    | otherwise             = Left ("Invalid suit:" ++ B8.unpack bs)
    -- TODO: Refactor using `reads`

{-
-- Print deck CSV file
printDeck :: IO ()
printDeck deckFile = do
    deckRaw <- 
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
            mainMenu
            -- loadGame
        's' -> do
            putStrLn "To be implemented"
            mainMenu
            -- seeStats
        'd' -> do
            putStrLn "To be implemented"
            mainMenu
            -- deleteStats
        'q' -> do
            exitGame Success
        _ -> do
            mainMenu


-- ================================================================
