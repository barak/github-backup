module Github.GetAuth where

import Utility.Env
import Data.Maybe
import System.IO

import Common
import qualified GitHub.Auth as Github
import qualified Data.ByteString.UTF8 as B

getAuth :: IO (Maybe Github.Auth)
getAuth = do
	oauthtoken <- getEnv "GITHUB_OAUTH_TOKEN"
	case oauthtoken of
		Just t -> return $ Just $ Github.OAuth (B.fromString t)
		Nothing -> do
			checkDeprecatedVars
			return Nothing

checkDeprecatedVars :: IO ()
checkDeprecatedVars = do
	user <- getEnv "GITHUB_USER"
	password <- getEnv "GITHUB_PASSWORD"
	when (isJust user && isJust password) $
		hPutStrLn stderr $ unwords
			[ "GITHUB_USER and GITHUB_PASSWORD are no longer"
			, "supported, because Github is removing that"
			, "authentication method."
			, "Set GITHUB_OAUTH_TOKEN instead."
			]
