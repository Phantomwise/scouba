-- ================================================================
-- HEADER
-- ================================================================


-- src/Menu.hs
module Menu where


-- ================================================================
-- LOCAL IMPORTS
-- ================================================================


import CreateDeck
import Exit


-- ================================================================
-- IMPORTS
-- ================================================================


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
