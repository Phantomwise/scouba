-- ================================================================
-- HEADER
-- ================================================================


-- src/Config.hs
module Config where


-- ================================================================
-- LOCAL IMPORTS
-- ================================================================


-- ================================================================
-- IMPORTS
-- ================================================================


-- ================================================================
-- CONFIGURATION
-- ================================================================


-- Enable/disable debug messages
debug :: Bool
debug = True


-- Decks Folder Path
decksFolderPath :: FilePath
decksFolderPath = "data/decks/"


-- Directory for the suit ASCII art
suitArtDir :: FilePath
suitArtDir = "data/suits/"


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
