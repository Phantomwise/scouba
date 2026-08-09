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


import System.Exit (ExitCode(..), exitWith, exitSuccess)
-- Needed to exit cleanly with an exit code
-- base


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
