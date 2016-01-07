module Main where

import Signal exposing (Signal, Mailbox, mailbox)
import Task
--import Time exposing (Time, every, second)

import Effects exposing (Effects)
import Html exposing (Html)
import StartApp exposing (start)

import Actions exposing (Action)
import Model exposing (Model)
import View


app : StartApp.App Model
app = start { init = init, view = View.view, update = update, inputs = [] }


main : Signal Html
main = app.html


init : (Model, Effects Action)
init = (Model.init, Effects.none )


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Actions.PlaySound soundName ->
      ( model, sendToJs soundName)
    Actions.NoOp ->
      ( model, Effects.none )
    Actions.SetAngel showing ->
      let
        updatedModel = {model | showingAngels = showing }
        effect = (
            if showing == True then
              clearAngel
            else
              Effects.none
          )
      in
        Debug.log "CALLING SETANGEL" ( updatedModel, effect )


clearAngel : Effects Action
clearAngel =
  Effects.task
    <| Task.sleep 3000
    `Task.andThen` \_ -> Task.succeed (Actions.SetAngel False)

sendToJs : String -> Effects Action
sendToJs soundName =
  Signal.send sounds.address soundName
    |> Task.toResult
    |> Task.map
      (
        \res ->
          case res of
            Ok val ->
              Debug.log "I WAS SENT YO" Actions.SetAngel True
            Err val ->
              Debug.log ("GOT AN ERROR AND IT IS" ++ val) Actions.NoOp
      )
    |> Effects.task


sounds : Mailbox String
sounds = mailbox ""


port playSound : Signal String
port playSound = sounds.signal
