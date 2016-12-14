module Animals.Main exposing (..)

import Animals.Msg exposing (..)
import Animals.OutsideWorld as OutsideWorld
import Animals.Navigation as MyNav
import Animals.Animal.Types as Animal
import Animals.Animal.Lenses exposing (..)
import Animals.Animal.Aggregates as Aggregate
import Animals.Animal.Form as Form
import Animals.Pages.PageFlash as PageFlash

import String
import List
import Dict
import Date exposing (Date)
import Pile.Calendar exposing (EffectiveDate(..))
import Pile.UpdatingLens exposing (lens)
import Return


-- Model and Init
type alias Flags =
  { csrfToken : String
  }

type alias Model = 
  { page : MyNav.PageChoice
  , csrfToken : String
  , animals : Aggregate.VisibleAggregate

  -- AllPage
  , nameFilter : String
  , tagFilter : String
  , speciesFilter : String
  , effectiveDate : EffectiveDate
  , today : Maybe Date
  , datePickerOpen : Bool

  -- AddPage
  , pageFlash : PageFlash.Flash
  }

model_page = lens .page (\ p w -> { w | page = p })
model_today = lens .today (\ p w -> { w | today = p })
model_animals = lens .animals (\ p w -> { w | animals = p })
model_tagFilter = lens .tagFilter (\ p w -> { w | tagFilter = p })
model_speciesFilter = lens .speciesFilter (\ p w -> { w | speciesFilter = p })
model_nameFilter = lens .nameFilter (\ p w -> { w | nameFilter = p })
model_effectiveDate = lens .effectiveDate (\ p w -> { w | effectiveDate = p })
model_datePickerOpen = lens .datePickerOpen (\ p w -> { w | datePickerOpen = p })
model_pageFlash = lens .pageFlash (\ p w -> { w | pageFlash = p })



init : Flags -> MyNav.PageChoice -> ( Model, Cmd Msg )
init flags startingPage =
  let
    model =
      { page = startingPage
      , csrfToken = flags.csrfToken
      , animals = Aggregate.emptyAggregate
      , nameFilter = ""
      , tagFilter = ""
      , speciesFilter = ""
      , effectiveDate = Today
      , today = Nothing
      , datePickerOpen = False
      , pageFlash = PageFlash.NoFlash
      }
  in
    model ! [OutsideWorld.askTodaysDate, OutsideWorld.fetchAnimals]

-- Update

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  update_ msg (model_pageFlash.set PageFlash.NoFlash model)

update_ : Msg -> Model -> ( Model, Cmd Msg )
update_ msg model =
  case msg of
    NavigateToAllPage ->
      MyNav.toAllPagePath model
    NavigateToAddPage ->
      MyNav.toAddPagePath model
    NavigateToHelpPage ->
      MyNav.toHelpPagePath model

    SetToday value ->
      model_today.set value model ! []
    SetAnimals animals ->
      model_animals.set (Aggregate.asAggregate animals) model ! []

    ToggleDatePicker ->
      model_datePickerOpen.update not model ! []
    SelectDate date ->
      model_effectiveDate.set (At date) model ! []
      
    SetNameFilter s ->
      model_nameFilter.set s model ! []
    SetTagFilter s ->
      model_tagFilter.set s model ! []
    SetSpeciesFilter s ->
      model_speciesFilter.set s model ! []

    MoreLikeThisAnimal id ->
      ( model 
      , Cmd.none
      )

    UpsertCompactAnimal animal flash ->
      (Animal.compact animal flash |> upsertDisplayedAnimal model) ! []
          
    UpsertExpandedAnimal animal flash ->
      (Animal.expanded animal flash |> upsertDisplayedAnimal model) ! []

    UpsertEditableAnimal animal form flash -> 
      (Animal.editable animal form flash |> upsertDisplayedAnimal model) ! []

    SaveAnimalChanges animal flash ->
      saveAnimalChanges animal flash model ! []

    CancelAnimalChanges animal flash ->
      case animal.wasEverSaved of
        True -> 
          (Animal.expanded animal flash |> upsertDisplayedAnimal model) ! []
        False ->
          deleteDisplayedAnimalById model animal.id ! [] 

    AddNewBovine ->
      (Form.freshEditableAnimal (Aggregate.freshId model.animals) |> upsertDisplayedAnimal model) ! []
        
    NoOp ->
      model ! []

upsertDisplayedAnimal model displayed =
  model_animals.update (Aggregate.upsert displayed) model

deleteDisplayedAnimalById model id  =
  model_animals.update (Aggregate.deleteById id) model

saveAnimalChanges animal flash model =
  let
    (animalToSave, modelToSave) = 
      case animal.wasEverSaved of
        True ->
          (animal, model)
        False ->
          ( animal_wasEverSaved.set True animal
          , model_pageFlash.set PageFlash.SavedAnimalFlash model
          )
  in
    Animal.expanded animalToSave flash |> upsertDisplayedAnimal modelToSave
    
-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
