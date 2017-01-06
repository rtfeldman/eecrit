module Animals.Animal.Types exposing
  (
  ..
  )

import Animals.Animal.Flash as Flash exposing (AnimalFlash(..))
import Pile.Bulma exposing (FormValue, FormStatus)
import Dict exposing (Dict)
import Date exposing (Date)
import Set exposing (Set)

type alias Id = String

type DictValue
  = AsInt Int String
  | AsFloat Float String
  | AsString String String
  | AsDate Date String
  | AsBool Bool String

type alias Animal =
  { id : Id
  , version : Int
  , name : String
  , species : String
  , tags : List String
  , properties : Dict String DictValue
  }

-- Todo: must be a way to use extensible types to
-- make templates nicer.
empty species =
  { id = "This id MUST be replaced"
  , version = 0
  , name = ""
  , species = species
  , tags = []
  , properties = Dict.empty
  }

  
type alias Form = 
  { id : Id
  , intendedVersion : Int
  , species : String
  , name : FormValue String
  , tags : List String
  , tentativeTag : String
  , properties : Dict String DictValue
  , status : FormStatus
  }

type Format
  = Compact
  | Expanded
  | Editable

type alias DisplayedAnimal = 
  { animal : Animal
  , format : Format
  , animalFlash : AnimalFlash
  }

type alias ValidationContext =
  { disallowedNames : List String
  }

