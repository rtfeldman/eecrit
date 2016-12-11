module Animals.Animal.Icons exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events

import Pile.HtmlShorthand exposing (..)

import Animals.Animal.Model exposing (..)
import Animals.Msg exposing (..)
import Animals.Animal.Edit exposing (..)

expand animal iconType =
  iconType "fa-caret-down"
    "Expand: show more about this animal"
    (UpsertExpandedAnimal animal NoFlash)
      
contract animal iconType =
  iconType "fa-caret-up"
    "Expand: show less about this animal"
    (UpsertCompactAnimal animal NoFlash)
      
edit animal iconType =
  iconType "fa-pencil"
    "Edit: make changes to this animal"
    (beginEditing animal)
      
moreLikeThis animal iconType =
  iconType "fa-plus"
    "Copy: make more animals like this one"
    (MoreLikeThisAnimal animal.id)

editHelp iconType = 
  iconType "fa-question-circle" "Help on editing" NoOp    
      
