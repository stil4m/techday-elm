import Html exposing (table, tr, td, div, button, text)
import Html.Events exposing (onClick)
import StartApp as StartApp

import Grid
import Effects exposing (Effects)

app : StartApp.App Model
app = StartApp.start
  { init = (init 10 10 10)
  , view = view
  , update = update
  , inputs = []
  }

main : Signal Html.Html
main = app.html

type alias Model =
  { grid : Grid.Model
  , counter : Int
  }

type Action = Increment | Decrement | GridAction Grid.Action | FetchedData (Maybe String)

init : Int -> Int -> Int -> (Model, Effects Action)
init width height bombs =
  ( { grid = fst (Grid.init width height bombs)
    , counter = 0
    }
  , Effects.none
  )

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
gridAction x model = { model | grid = fst (Grid.update x model.grid)}

update : Action -> Model -> (Model, Effects Action)
update action model =
  ( case action of
      GridAction x -> gridAction x model
      Increment -> decrement model
      Decrement -> increment model
      FetchedData _ -> model
  , Effects.none
  )
