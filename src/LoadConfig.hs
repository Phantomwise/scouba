-- ================================================================
-- HEADER
-- ================================================================


-- src/Config.hs
module LoadConfig where


-- ================================================================
-- LOCAL IMPORTS
-- ================================================================


-- import Config


-- ================================================================
-- EXTERNAL IMPORTS
-- ================================================================


import System.Environment (lookupEnv)


-- ================================================================
-- GET PATHS
-- ================================================================


sysDataEnv    :: String = "SCOUBA_SYSDATA"
sysConfigEnv  :: String = "SCOUBA_SYSCONFIG"
userDataEnv   :: String = "SCOUBA_USERDATA"
userConfigEnv :: String = "SCOUBA_USERCONFIG"

-- Resolve paths
resolvePaths :: String -> IO FilePath
resolvePaths env = do
	result <- lookupEnv env
	case result of
		Nothing               -> return ""
		Just path | null path -> return path -- NB: `|` is an `and if`, not `or if`
		Just path             -> return path


-- ================================================================
