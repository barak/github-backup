{- Checks system configuration and generates SysConfig. -}

{-# OPTIONS_GHC -fno-warn-tabs #-}

module Build.Configure where

import Control.Monad.IfElse
import Control.Applicative
import Prelude

import Build.TestConfig
import Build.Version
import Git.Version

tests :: [TestCase]
tests =
	[ TestCase "version" (Config "version" . StringConfig <$> getVersion)
	, TestCase "git" $ testCmd "git" "git --version >/dev/null"
	, TestCase "git version" getGitVersion
	]

getGitVersion :: Test
getGitVersion = Config "gitversion" . StringConfig . show
	<$> Git.Version.installed

run :: [TestCase] -> IO ()
run ts = do
	config <- runTests ts
	writeSysConfig config
	whenM (isReleaseBuild) $
		cabalSetup "github-backup.cabal"
