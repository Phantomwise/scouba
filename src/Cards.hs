-- ================================================================
-- HEADER
-- ================================================================


-- src/Cards.hs
module Cards where


-- ================================================================
-- LOCAL IMPORTS
-- ================================================================


import AnsiColorLite (AnsiColor8(..), ansi)
import Config


-- ================================================================
-- IMPORTS
-- ================================================================


import Data.Char
-- Needed for toLower


-- ================================================================
-- CARDS DEFINITIONS
-- ================================================================


-- Define data type for card suit
data Suit = Spades | Hearts | Clubs | Diamonds | Swords | Cups | Batons | Coins
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


-- ================================================================
-- CARDS HELPERS
-- ================================================================


-- Function to identify face cards
isFace :: Rank -> Bool
isFace x
    | x == Jack = True
    | x == Queen = True
    | x == King = True
    | otherwise = False
-- Not yet in use


-- Function to assign a display color to a suit
suitColor :: Suit -> AnsiColor8
suitColor x
    | elem x [Spades,   Swords] = Blue
    | elem x [Hearts,   Cups]   = Red
    | elem x [Clubs,    Batons] = Green
    | elem x [Diamonds, Coins]  = Magenta
    | otherwise                 = Black


-- Function to determine the display color of a card
cardColor :: Card -> AnsiColor8
cardColor x = suitColor (suit x)
-- Not yet in use


-- Function to get the filename of the ascii art for a suit (directory path and size variable defined in Config.hs)
suitArtPath :: Suit -> FilePath
suitArtPath s = suitArtDir ++ map toLower (show s) ++ "-" ++ suitArtSize ++ ".txt"
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
