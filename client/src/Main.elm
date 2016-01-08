module Main where

import Signal exposing (Signal, Mailbox, mailbox)
import Task

import Effects exposing (Effects)
import Html exposing (Html)
import StartApp exposing (start)

import Actions exposing (Action)
import Model exposing (Model)
import View


app : StartApp.App Model
app =
  start { init = init, view = View.view, update = update, inputs = [doneActions] }


main : Signal Html
main =
  app.html


init : (Model, Effects Action)
init =
  (Model.init, Effects.none )


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Actions.PlaySound soundName ->
      Debug.log "WAT" ( model, sendToJs soundName)
    Actions.NoOp ->
      ( model, Effects.none )
    Actions.SetAngel showing ->
      Debug.log "CALLING SETANGEL" ({model | showingAngels = showing }, Effects.none )

sendToJs : String -> Effects Action
sendToJs soundName =
  Signal.send mail.address soundName
    |> Task.toResult
    |> Task.map (\res ->
          case res of
            Ok val ->
              Actions.SetAngel True
            Err val ->
              Actions.NoOp
    )
    |> Effects.task


mail : Mailbox String
mail = mailbox ""


port stuff : Signal String
port stuff = mail.signal

-- TODO: how to map over the incoming port?
port done : Signal Bool


doneActions : Signal Action
doneActions = Signal.map (\_ -> Actions.SetAngel False) done



port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks


clearAngel : Effects Action
clearAngel =
  Effects.task
    <| Task.sleep 3000
    `Task.andThen` \_ -> Task.succeed (Actions.SetAngel False)
