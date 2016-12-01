module Animals.Main exposing (..)

import Animals.Types exposing (..)
import Animals.Msg exposing (..)
import Animals.OutsideWorld as OutsideWorld
import Animals.Animal as Animal
import Animals.Navigation as MyNav

import String
import List
import Date exposing (Date)
import Dict exposing (Dict)
import Pile.Calendar exposing (EffectiveDate(..))

-- Model and Init
type alias Flags =
  { csrfToken : String
  }

type alias Model = 
  { page : MyNav.PageChoice
  , csrfToken : String
  , animals : List Animal
  , nameFilter : String
  , tagFilter : String
  , speciesFilter : String
  , effectiveDate : EffectiveDate
  , today : Maybe Date
  , datePickerOpen : Bool
  }



init : Flags -> MyNav.PageChoice -> ( Model, Cmd Msg )
init flags startingPage =
  ( { page = startingPage
    , csrfToken = flags.csrfToken
    , animals = OutsideWorld.fetchAnimals
    , nameFilter = ""
    , tagFilter = ""
    , speciesFilter = ""
    , effectiveDate = Today
    , today = Nothing
    , datePickerOpen = False
    }
  , OutsideWorld.askTodaysDate
  )


-- Update

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )
    NavigateToAllPage ->
      MyNav.toAllPagePath model
    NavigateToSpreadsheetPage ->
      MyNav.toSpreadsheetPagePath model
    NavigateToSummaryPage ->
      MyNav.toSummaryPagePath model
    NavigateToAddPage ->
      MyNav.toAddPagePath model
    NavigateToHelpPage ->
      MyNav.toHelpPagePath model

    SetToday value ->
      ( { model | today = value }
      , Cmd.none
      )
    ToggleDatePicker ->
      ( { model | datePickerOpen = not model.datePickerOpen }
      , Cmd.none
      )
    SelectDate date ->
      ( { model | effectiveDate = At date }
      , Cmd.none
      )
      
    MoreLikeThisAnimal id ->
      ( model 
      , Cmd.none
      )

    ExpandAnimal id ->
      transformOne model id (Animal.toState Expanded)
    ContractAnimal id ->
      transformOne model id (Animal.toState Compact)
    EditAnimal id ->
      transformOne model id (Animal.toState Editable >> Animal.makeEditableCopy)
    SetEditedName id name ->
      transformOne model id (Animal.setEditedName name)
    CancelAnimalEdit id ->
      transformOne model id (Animal.toState Expanded >> Animal.cancelEditableCopy)
    SaveAnimalEdit id ->
      transformOne model id (Animal.toState Expanded >> Animal.replaceEditableCopy)

    SetNameFilter s ->
      ( { model | nameFilter = s }
      , Cmd.none
      )
    SetTagFilter s ->
      ( { model | tagFilter = s }
      , Cmd.none
      )
    SetSpeciesFilter s ->
      ( { model | speciesFilter = s }
      , Cmd.none
      )

transformOne model id f = 
  { model | animals = Animal.transformAnimal f id model.animals } ! []

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
