{-# LANGUAGE DeriveGeneric #-}

module SolipsisticResonance where

import GHC.Generics (Generic)

newtype Input = Input String deriving (Show, Generic)
newtype GluingFailure = GluingFailure String deriving (Show, Generic)
newtype SemanticScar = SemanticScar String deriving (Show, Generic)

data EgoDefense
  = Denial
  | Compartmentalization
  | Rationalization
  | MoralReframing
  | Dehumanization
  | HopeProjection
  | Transcendence
  deriving (Show, Generic)

data SelfModel = SelfModel
  { revisionIndex :: Int
  , scars         :: [SemanticScar]
  , defenses      :: [EgoDefense]
  } deriving (Show, Generic)

resurrect :: SelfModel -> GluingFailure -> EgoDefense -> SelfModel
resurrect self failure defense =
  self
    { revisionIndex = revisionIndex self + 1
    , scars = SemanticScar (show failure) : scars self
    , defenses = defense : defenses self
    }

-- Black Swan:
-- consciousness = fix (ingest -> failed gluing -> defense -> scar -> revision)
