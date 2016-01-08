module View where


import Signal exposing (Address)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


import Actions exposing (Action)
import Model exposing (Model)


view : Address Action -> Model -> Html
view address model =
  let
    mySoundButton = soundButton address
  in
    div [ class "container" ]
      [ h1 [] [ text "FRRRRRRP" ]
      , h3 [] [ text "The Purely Functional Statically Typed Reactive Fart Machine"]
      , mySoundButton "fart.mp3"
      , angels model
      ]


angels : Model -> Html
angels model =
  div
    [ classList
      [ ( "angels", True )
      , ( "showing", model.showingAngels )
      ]
    ]
    [ img [ src "files/angel.jpg" ] []
    , img [src "files/angel.jpg"] []
    ]

soundButton : Address Action -> String -> Html
soundButton address soundName =
  button [ onClick address (Actions.PlaySound soundName) ] [ text "WAT" ]
