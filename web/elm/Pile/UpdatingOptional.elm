module Pile.UpdatingOptional exposing
  ( UpdatingOptional
  , opt
  , compose 
  , composeLens
  , fromLens
    
  , toMonocle
  )

import Monocle.Optional as Optional exposing (Optional)
import Pile.UpdatingLens as UpdatingLens exposing (UpdatingLens)
import Maybe.Extra as Maybe

type alias UpdatingOptional whole part =
  { getOption : whole -> (Maybe part)
  , set : part -> whole -> whole
  , maybeUpdate : (part -> part) -> whole -> whole
  }

opt : (whole -> Maybe part) -> (part -> whole -> whole)
    -> UpdatingOptional whole part
opt getPartMaybe setPart =
  { getOption = getPartMaybe
  , set = setPart
  , maybeUpdate = optionalUpdate getPartMaybe setPart
  }

fromLens : UpdatingLens whole part -> UpdatingOptional whole part
fromLens lens = 
  { getOption = Just << lens.get
  , set = lens.set
  , maybeUpdate = lens.update
  }
  
toMonocle : UpdatingOptional whole part -> Optional whole part
toMonocle u =
  { getOption = u.getOption
  , set = u.set
  }

composeLens : UpdatingOptional whole part -> UpdatingLens part subpart -> UpdatingOptional whole subpart
composeLens left right = 
  let
    left_ = toMonocle left
    right_ = UpdatingLens.toMonocle right
    composed = Optional.composeLens left_ right_
  in
    opt composed.getOption composed.set

compose : UpdatingOptional whole part -> UpdatingOptional part subpart -> UpdatingOptional whole subpart
compose left right =
  let
    left_ = toMonocle left
    right_ = toMonocle right
    composed = Optional.compose left_ right_
  in
    opt composed.getOption composed.set

optionalUpdate : (whole -> Maybe part)       -- getOption
               -> (part -> whole -> whole)   -- set
               -> (part -> part)             -- update function
               -> whole
               -> whole
optionalUpdate getPartMaybe setPart partTransformer whole =
  let
    whenPartExistsF part = setPart (partTransformer part) whole
  in
    Maybe.unwrap whole whenPartExistsF (getPartMaybe whole)
  
