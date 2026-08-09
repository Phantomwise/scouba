-- ================================================================
-- HEADER
-- ================================================================


-- src/Display.hs
module Display where


-- ================================================================
-- LOCAL IMPORTS
-- ================================================================


import AnsiColorLite (AnsiColor8(..), ansi)
import Config


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
