-- ================================================================
-- HEADER
-- ================================================================


-- src/Exit.hs
module Exit where


-- ================================================================
-- LOCAL IMPORTS
-- ================================================================


import Display


-- ================================================================
-- IMPORTS
-- ================================================================


import System.Exit (ExitCode(..), exitWith, exitSuccess)
-- Needed to exit cleanly with an exit code
-- base


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
