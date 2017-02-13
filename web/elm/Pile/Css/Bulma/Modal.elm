module Pile.Css.Bulma.Modal exposing (..)

import Pile.Css.H exposing (..)
import Pile.Css.Bulma.Util as Util
import Pile.Css.Bulma as Bulma

import Html exposing (..)
import Html.Attributes exposing (class)
import Pile.HtmlShorthand exposing (..)

modal : String -> List (Html msg) -> msg -> msg -> Html msg
modal title body saveMsg cancelMsg =
  div [class "modal is-active"]
    [ div [class "modal-background"] []
    , div [class "modal-card" ]
      [ header [class "modal-card-head"]
          [ p [class "modal-card-title"] [text title]
          , xCancel cancelMsg
          ]
      , section [class "modal-card-body"] body
      , footer [class "modal-card-foot"]
        [ save saveMsg
        , cancel cancelMsg
        ]
      ]
    ]
    
save msg =
  a [ class "button is-success pull-left"
    , onClickPreventingDefault msg
    ]
    [ span [class "icon"] [i [class "fa fa-check"] []]
    , text "Save"
    ]


cancel : msg -> Html msg
cancel msg =
  p []
    [ a [ class <| "button pull-right"
        , onClickPreventingDefault msg
        ]
        [ span [class "icon"] [i [class "fa fa-times"] []]
        , text "Cancel"
        ]
    ]
    
xCancel : msg -> Html msg
xCancel msg = 
  button [ class "delete"
         , onClickPreventingDefault msg
         ] []
