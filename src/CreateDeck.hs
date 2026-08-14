-- ================================================================
-- HEADER
-- ================================================================


-- src/CreateDeck.hs
module CreateDeck where


-- ================================================================
-- LOCAL IMPORTS
-- ================================================================


import AnsiColorLite (AnsiColor8(..), ansi)
import Cards
import Config
import Display
import Exit


-- ================================================================
-- EXTERNAL IMPORTS
-- ================================================================


import System.Directory (doesFileExist)
-- Needed to check if files exist
-- base

import qualified Data.ByteString.Char8 as B8
-- Needed to implement manual parsing and preserve my sanity from Cassava
-- Char8 allows using `,` and `\n` instead of the byte sequences `44` and `10`

import Text.Pretty.Simple (pPrint)


-- ================================================================
-- CREATE DECK
-- ================================================================


-- Create Deck
createDeck :: IO (Either String [Card]) -- Change to `IO [(i,Card)]` later when extraction and shuffling works]
createDeck = do
    deckChoice <- askForDeck                                                                -- Char <- IO Char
    let deckPath            :: FilePath             = matchDeck deckChoice                  -- FilePath = Char -> FilePath
    checkDeckFile deckPath                                                                  -- FilePath -> IO ()
    deckB8                  :: B8.ByteString        <- readDeckFileBytestring deckPath      -- B8.ByteString <- IO B8.ByteString
    -- printDebug ("ByteString Deck: (putStrLn show)")                                         -- IO ()
    -- putStrLn (show deckB8)                                                                  -- IO ()
    printDebug ("ByteString Deck:")                                                         -- String -> IO ()
    pPrint deckB8                                                                           -- Show B8.ByteString => B8.ByteString -> IO ()
    let deckB8List          :: [[B8.ByteString]]    = parseDeckFileManualB8 deckB8          -- [[B8.ByteString]] = B8.ByteString -> [[B8.ByteString]]
    -- printDebug ("ByteString Deck parsed as a List of Lists:")                               -- IO ()
    -- putStrLn (show deckB8List)                                                              -- IO ()
    printDebug ("ByteString Deck parsed as a List of Lists:")                               -- String -> IO ()
    pPrint deckB8List                                                                       -- Show [[B8.ByteString]] => [[B8.ByteString]] -> IO ()
    let deckB8ListFiltered  :: [[B8.ByteString]]    = filterDeckEmptyRows deckB8List        -- [[B8.ByteString]] = [[B8.ByteString]] -> [[B8.ByteString]]
    -- printDebug ("ByteString Deck with empty rows filtered out:")                            -- IO ()
    -- putStrLn (show deckB8ListFiltered)                                                      -- IO ()
    printDebug ("ByteString Deck with empty rows filtered out:")                            -- String -> IO ()
    pPrint deckB8ListFiltered                                                               -- Show [[B8.ByteString]] => [[B8.ByteString]] -> IO ()
    let deckB8DropHeader    :: [[B8.ByteString]]    = drop 1 deckB8ListFiltered             -- [[B8.ByteString]] = Int -> [[B8.ByteString]] -> [[B8.ByteString]]
    -- printDebug ("ByteString Deck with empty rows filtered out and row 1 dropped:")          -- IO ()
    -- putStrLn (show deckB8DropHeader)                                                        -- IO ()
    printDebug ("ByteString Deck with empty rows filtered out and row 1 dropped:")          -- String -> IO ()
    pPrint deckB8DropHeader                                                                 -- Show [[B8.ByteString]] => [[B8.ByteString]] -> IO ()
    let deckB8Final         :: [[B8.ByteString]]    = deckB8DropHeader                      -- [[B8.ByteString]] = [[B8.ByteString]]
    -- printDebug ("ByteString Deck final:")                                                   -- IO ()
    -- putStrLn (show deckB8Final)                                                             -- IO ()
    printDebug ("ByteString Deck final:")                                                   -- String -> IO ()
    pPrint deckB8Final                                                                      -- Show [[B8.ByteString]] => [[B8.ByteString]] -> IO ()
    let deckFinal           :: Either String [Card] = parseDeckToListOfCards deckB8Final    -- Either String [Card] = [[B8.ByteString]] -> Either String [Card]
    -- printDebug ("Card Deck final:")                                                         -- IO ()
    -- putStrLn (show deckFinal)                                                               -- IO ()
    printDebug ("Card Deck final:")                                                         -- String -> IO ()
    pPrint deckFinal                                                                        -- Show (Either String [Card]) => Either String [Card] -> IO ()
    return deckFinal                                                                        -- Either String [Card] -> IO (Either String [Card])


askForDeck :: IO Char
askForDeck = do
    putStrLn ""
    putStrLn "Please choose a deck: "
    putStrLn "1. French deck, 52 cards"
    putStrLn "2. French deck, 40 cards"
    putStrLn "3. Italian deck, 40 cards"
    deckChoice <- getChar
    _ <- getLine
    return deckChoice


matchDeck :: Char -> FilePath
matchDeck d
    | d == '1' = decksFolderPath ++ "52-French.csv"
    | d == '2' = decksFolderPath ++ "40-French.csv"
    | d == '3' = decksFolderPath ++ "40-Italian.csv"
    | otherwise = decksFolderPath ++ "52-French.csv"


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
parseRowToCard [nm, name, suit, rank] =
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
                                Right r -> Right (Card { nm = n, name = na, suit = s, rank = r, value = rankValue r } )

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

-- Parse Suit field
parseSuit :: B8.ByteString -> Either String Suit
parseSuit bs
    | bs == B8.pack "Spades"   = Right Spades
    | bs == B8.pack "Hearts"   = Right Hearts
    | bs == B8.pack "Clubs"    = Right Clubs
    | bs == B8.pack "Diamonds" = Right Diamonds
    | bs == B8.pack "Swords"   = Right Swords
    | bs == B8.pack "Cups"     = Right Cups
    | bs == B8.pack "Batons"   = Right Batons
    | bs == B8.pack "Coins"    = Right Coins
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
