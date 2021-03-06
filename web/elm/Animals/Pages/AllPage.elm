module Animals.Pages.AllPage exposing (view)

import Animals.Pages.Common as Common
import Animals.View.PageFlash as PageFlash

import Animals.Types.Lenses exposing (..)
import Animals.Types.Displayed as Displayed exposing (Displayed)
import Animals.Types.ModalOverlay as Overlay
import Animals.Msg exposing (..)
import Animals.Model exposing (Model)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pile.Css.Bulma as Css
import Pile.Css.Bulma.Button as Css
import Pile.Namelike as Namelike exposing (Namelike)
import Pile.DateHolder as DateHolder

view : Model -> Html Msg
view model =
  div []
    [ Css.centeredColumns
        [ Css.column 3 <| effectiveDate model
        , Css.column 8 <| filters model 
        ]
    , PageFlash.show model.pageFlash
    , Css.headerlessTable <| animalViews model
    ]

animalViews : Model -> List (Html Msg)    
animalViews model =
  let
    displayed = Common.pageAnimals .allPageAnimals model
    animalViewer = Common.individualAnimalView model (StartSavingEdits, CancelEdits)
  in
    displayed
      |> applyFilters model
      |> List.map animalViewer


effectiveDate : Model -> List (Html Msg)
effectiveDate model =
  let
    specialistButton =
      Css.rawButton "button is-primary is-small pull-right" 
  in
    [ Css.messageView
        [ text "Show animals as of..."
        , calendarHelp Css.rightIcon
        ]
        [ p [class "has-text-centered"]
            [ span [class "control"]
                [ text (DateHolder.enhancedDateString model.effectiveDate) ]
            , specialistButton "Change" { click = Just (withoutArg OpenDatePicker) }
            ]
        ]
    ]
    
      


  
filters : Model -> List (Html Msg)
filters model = 
  [ Css.messageView 
      [ text "Filter by..."
      , filterHelp Css.rightIcon
      ]
      [ Css.distributeHorizontally
          [ nameFilter model
          , speciesFilter model
          , tagsFilter model 
          ]
      ]
  ]

applyFilters : Model -> List Displayed -> List Displayed
applyFilters model xs = 
  let
    rightSpecies =
      displayed_species.get >> Namelike.isPrefix model.speciesFilter

    rightName = 
      displayed_name.get >> Namelike.isPrefix model.nameFilter
        
    rightTag =
      displayed_tags.get >> Namelike.isTagListAllowed model.tagFilter
  in
    xs
      |> List.filter (aggregateFilter [rightSpecies, rightName, rightTag])
      |> Namelike.sortByName displaySortKey

displaySortKey : Displayed -> Namelike
displaySortKey displayed =
  case displayed.view of
    Displayed.Writable form -> form.sortKey
    Displayed.Viewable animal -> animal.name 

aggregateFilter : List (Displayed -> Bool) -> Displayed -> Bool
aggregateFilter preds animal =
  case preds of
    [] ->
      True
    p :: ps ->
      if (p animal) then
        aggregateFilter ps animal
      else
        False


-- -- The calendar

dateControl : Bool -> String -> msg -> Html msg
dateControl hasOpenPicker displayString calendarToggleMsg =
  let
    iconF =
      case hasOpenPicker of
        False -> Css.plainIcon "fa-caret-down" "Pick a date from a calendar" 
        True -> Css.plainIcon "fa-caret-up" "Close the calendar"
  in
    p [class "has-text-centered"]
      [ text displayString
      , iconF calendarToggleMsg
      ]

-- -- Filters

nameFilter : Model -> Html Msg
nameFilter model =
  Css.centeredLevelItem
    [ Css.headingP "Name"
    , Css.simpleTextInput model.nameFilter <| withArg SetNameFilter
    ]

tagsFilter : Model -> Html Msg
tagsFilter model =
  Css.centeredLevelItem
    [ Css.headingP "Tag"
    , Css.simpleTextInput model.tagFilter <| withArg SetTagFilter
    ]

speciesFilter : Model -> Html Msg
speciesFilter model =
  Css.centeredLevelItem
    [ Css.headingP "Species" 
    , Css.simpleSelect
        (OnAllPage << SetSpeciesFilter)
        [ (" ", "Any")  -- The space works around a possible VirtualDom bug.
        , ("bovine", "bovine")
        , ("equine", "equine")
        ]
        model.speciesFilter
    ]
      
-- -- Various icons
    
calendarHelp : Css.IconExpander Msg -> Html Msg
calendarHelp iconType = 
  iconType "fa-question-circle" "Help on animals and dates"
    (SetOverlay Overlay.AllPageCalendarHelp)

filterHelp : Css.IconExpander Msg -> Html Msg
filterHelp iconType = 
  iconType "fa-question-circle" "Help on filtering"
    (SetOverlay Overlay.AllPageFilterByHelp)


-- Util
    
withArg : (opArg -> AllPageOperation) -> opArg -> Msg
withArg opArg = 
  opArg >> OnAllPage

withoutArg : AllPageOperation -> Msg
withoutArg = OnAllPage
  
