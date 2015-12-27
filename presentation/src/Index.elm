import Html exposing (table, tr, td, div, button, text)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp

import Grid

import Debug

main : Signal Html.Html
main = StartApp.start
  { model = (Debug.watch "Model" (init 5 5))
  , view = view
  , update = update
  }

type alias Model =
  { grid : Grid.Model
  , counter : Int
  }

type Action = Increment | Decrement | GridAction Grid.Action | FetchedData (Maybe String)

init : Int -> Int -> Model
init width height =
  { grid = Grid.init width height
  , counter = 0
  }

view : Signal.Address Action -> Model -> Html.Html
view address model =
  div []
    [ Grid.view (Signal.forwardTo address GridAction) model.grid
    , button [ onClick address Decrement ] [ text "-" ]
    , div [] [ text (toString model.counter) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]

-- update
increment : Model -> Model
increment model = { model | counter = model.counter - 1 }

decrement : Model -> Model
decrement model = { model | counter = model.counter + 1 }

gridAction : Grid.Action -> Model -> Model
gridAction x model = { model | grid = Grid.update x model.grid}

update : Action -> Model -> Model
update action model =
  case action of
    GridAction x -> gridAction x model
    Increment -> decrement model
    Decrement -> increment model
    FetchedData _ -> model
