module Animals.Logic.AddPageOp exposing
  ( update
  )

import Animals.Model as Model exposing (..)
import Animals.Msg exposing (..)

import Pile.UpdateHelpers exposing (..)
import Pile.Calendar as Calendar
import Pile.ConstrainedStrings exposing (updateIfPotentialIntString)

update : AddPageOperation -> Model -> (Model, Cmd Msg)
update op model = 
  case op of
    SetAddedSpecies species ->
      model |> model_speciesToAdd.set species |> noCmd

    UpdateAddedCount countString ->
      model |> updateIfPotentialIntString countString model_numberToAdd |> noCmd