module Animals.View.Animal exposing (compactView, expandedView)

import Html exposing (..)
import Animals.Types.Animal as Animal exposing (Animal)
import Animals.Types.Basic exposing (..)

import Pile.Css.Bulma as Css
import Pile.Css.Bulma.Button as Css
import Pile.Date as Date

import Animals.Msg exposing (..)

import Animals.View.Icons as Icon
import Animals.View.AnimalFlash as AnimalFlash exposing (AnimalFlash)

import Dict
import List

import Animals.Msg exposing (..)


compactView : Animal -> AnimalFlash -> Html Msg
compactView animal flash =
  tr []
    [ (td []
         [ p [] ( animalSalutation animal  :: animalTags animal)
         , AnimalFlash.showWithButton flash (WithAnimal animal RemoveAnimalFlash)
           ])
      , Icon.expand animal Css.tdIcon
      , Icon.edit animal Css.tdIcon
      , Icon.moreLikeThis animal.id Css.tdIcon
      ]

expandedView : Animal -> AnimalFlash -> Html Msg      
expandedView animal flash =
    Css.highlightedRow []
      [ td []
          [ p [] [ animalSalutation animal
                 , text Css.emsp
                 , Css.smallPrimaryButton
                     "See History"
                     { click = Just (NewHistoryPage animal) }
                 ]
          , p [] (animalTags animal)
          , animalProperties animal |> Css.propertyTable
          , AnimalFlash.showWithButton flash (WithAnimal animal RemoveAnimalFlash)
          , p [] [ creationDate animal ]
          ]
      , Icon.contract animal Css.tdIcon
      , Icon.edit animal Css.tdIcon
      , Icon.moreLikeThis animal.id Css.tdIcon
      ]
      
-- Util

animalProperties : Animal -> List (Html msg)
animalProperties animal =
  let
    row (key, value) = 
      tr []
        [ td [] [text key]
        , td [] (propertyDisplayValue value)
        ]
    propertyPairs = Dict.toList (animal.properties)
  in
      List.map row propertyPairs

propertyDisplayValue : DictValue -> List (Html msg)
propertyDisplayValue value =     
  case value of
    AsBool b m -> boolExplanation b m
    AsString s _ -> [text s]
    _ -> [text "unimplemented"]

boolExplanation : Bool -> String -> List (Html msg)
boolExplanation b explanation = 
  let
    icon = case b of
             True -> Css.trueIcon
             False -> Css.falseIcon
    suffix = case explanation of
               "" -> ""
               s -> " (" ++ s ++ ")"
  in
    [icon, text suffix]



animalSalutation : Animal -> Html msg
animalSalutation animal =
  text <| animal.name ++ (parentheticalSpecies animal)

creationDate : Animal -> Html msg    
creationDate animal =
   text <| "Created on " ++ Date.humane animal.creationDate
    
animalTags : Animal -> List (Html Msg)
animalTags animal =
  List.map Css.readOnlyTag animal.tags

parentheticalSpecies : Animal -> String
parentheticalSpecies animal =
  " (" ++ animal.species ++ ")"
