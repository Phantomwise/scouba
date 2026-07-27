-- ================================================================
-- CONFIG
-- ================================================================


-- app/Main.hs
module Config where


-- ================================================================
-- LOCAL IMPORTS
-- ================================================================


-- ================================================================
-- CONFIGURATION
-- ================================================================


-- Enable/disable debug messages
debug :: Bool
debug = True


-- Deck File Path
deckFilePath :: FilePath
deckFilePath = "data/deck.csv"


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
