module Animals.Animal.Form exposing (..)

import Dict
import Pile.Namelike as Namelike

import Pile.Bulma as Bulma exposing
  (FormStatus(..), FormValue, Urgency(..), Validity(..))

import Animals.Animal.Types exposing (..)
import Animals.Animal.Flash as AnimalFlash exposing (AnimalFlash)

extractForm : Animal -> Form
extractForm animal =
  { status = AllGood
  , id = animal.id
  , species = animal.species
  , intendedVersion = animal.version + 1
  , name = Bulma.freshValue animal.name
  , tags = animal.tags
  , tentativeTag = ""
  , properties = animal.properties
  }

-- This is used as the default value in "impossible" cases.
nullForm : Form
nullForm =
  { status = SomeBad
  , id = "impossible"
  , species = "impossible"
  , intendedVersion = -1
  , name = Bulma.freshValue "you should never see this"
  , tags = []
  , tentativeTag = ""
  , properties = Dict.empty
  }

assumeValid : Form -> Form 
assumeValid form =
  { form
    | status = AllGood
    , name = Bulma.freshValue form.name.value
  } 

  
  
-- -- Constructing Messages and other Important Actions

appliedForm : Form -> Animal
appliedForm form =
  { id = form.id
  , version = form.intendedVersion
  , name = form.name.value
  , species = form.species
  , tags = Namelike.perhapsAdd form.tentativeTag form.tags
  , properties = form.properties
  }

saveFlash : Form -> AnimalFlash
saveFlash form =
  case Namelike.isValidAddition form.tentativeTag form.tags of
    True -> AnimalFlash.SavedIncompleteTag form.tentativeTag
    False -> AnimalFlash.NoFlash
