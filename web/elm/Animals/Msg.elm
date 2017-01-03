module Animals.Msg exposing (..)

import Animals.Pages.Declare exposing (PageChoice)
import Animals.OutsideWorld.Declare as OutsideWorld
import Animals.Animal.Types as Animal exposing (Animal)
import Date exposing (Date)
import Navigation
import Http

-- A subtype of Msg. Always used as `WithAnimal <displayedAnimal> <submsg>`
type AnimalOperation
  = RemoveFlash
  | SwitchToReadOnly Animal.Format

type Msg
  = NoticePageChange Navigation.Location
  | StartPageChange PageChoice

  | SetToday (Maybe Date)
  | SetAnimals (Result Http.Error (List Animal))

  | ToggleDatePicker
  | SelectDate Date

  | SetNameFilter String
  | SetTagFilter String
  | SetSpeciesFilter String

  | SwitchToEditView Animal.DisplayedAnimal

  | CheckFormChange Animal.DisplayedAnimal Animal.Form 
    
  | CancelAnimalEdits Animal.DisplayedAnimal Animal.Form
  | CancelAnimalCreation Animal.DisplayedAnimal Animal.Form
    
  | StartSavingAnimalEdits Animal.DisplayedAnimal Animal.Form
  | StartCreatingNewAnimal Animal.DisplayedAnimal Animal.Form

  | NoticeAnimalSaveResults (Result Http.Error OutsideWorld.AnimalSaveResults)
  | NoticeAnimalCreationResults (Result Http.Error OutsideWorld.AnimalCreationResults)

  | AddNewAnimals Int String

  | MoreLikeThisAnimal Animal.DisplayedAnimal

  | WithAnimal Animal.DisplayedAnimal AnimalOperation
  | NoOp

