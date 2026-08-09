-- ================================================================
-- HEADER
-- ================================================================


-- src/CreateDeck.hs
module CreateDeck where


-- ================================================================
-- LOCAL IMPORTS
-- ================================================================


import Cards
import Config
import Unsorted


-- ================================================================
-- IMPORTS
-- ================================================================


import System.Directory (doesFileExist)
-- Needed to check if files exist
-- base

import qualified Data.ByteString.Char8 as B8
-- Needed to implement manual parsing and preserve my sanity from Cassava
-- Char8 allows using `,` and `\n` instead of the byte sequences `44` and `10`


-- ================================================================
-- CREATE DECK
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
