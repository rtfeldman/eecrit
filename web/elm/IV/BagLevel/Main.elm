module IV.BagLevel.Main exposing (..)

import Animation
import IV.BagLevel.View as View
import IV.Types exposing (..)
import Time exposing (second)
import IV.Pile.Animation as APile

--- Model

type alias Model =
  { style : Animation.State
  }

animations : Model -> List Animation.State
animations model =
  [model.style]

-- Msg

type Msg
  = StartSimulation Hours Level
  | AnimationClockTick Animation.Msg

-- Update

startingState : Level -> Model 
startingState level =
  { style = Animation.style <| View.animationProperties level }

update : Msg -> Model -> Model
update msg model =
  case msg of
    StartSimulation hours level ->
      { model | style = drainBag hours level model.style }

    AnimationClockTick tick ->
      { model | style = (Animation.update tick) model.style }



drainBag : Hours -> Level -> Animation.State -> Animation.State
drainBag hours level animation =
  let
    ease = APile.easeForHours hours
    change = [Animation.toWith ease (View.animationProperties level)]
  in
    Animation.interrupt change animation
