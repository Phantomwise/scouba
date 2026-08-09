-- ================================================================
-- HEADER
-- ================================================================


-- src/Unsorted.hs
module Unsorted where


-- ================================================================
-- LOCAL IMPORTS
-- ================================================================


import Config
import AnsiColorLite (AnsiColor8(..), ansi)


-- ================================================================
-- IMPORTS
-- ================================================================


-- Cassava imports:
-- Not used, can't understand how to use the module so doing manual parsing for now. Kept for later.

-- import Data.Csv
-- Cassava module
-- Needed to parse CSV data
-- haskellPackages.cassava
-- Not yet in use
-- TODO: REMOVE

-- import qualified Data.ByteString.Lazy as BL
-- Needed by cassava to read CSV
-- TODO: find out what the hell lazy bytestrings are
-- TODO: REMOVE

-- import qualified Data.ByteString.Lazy.Char8 as BLC
-- Needed by BLC.unpack to convert a ByteString into a String
-- TODO: REMOVE


-- ================================================================
-- DISPLAY
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
