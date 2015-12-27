import Html exposing (table, tr, td, div, button, text)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp
import Box
import Debug

main : Signal Html.Html
main = StartApp.start
  { model = (Debug.watch "Model" (init 5 5))
  , view = view
  , update = update
  }

type alias Model =
  { grid : List (List (Int, Box.Model))
  , counter : Int
  }

type Action = Increment | Decrement | BoxAction Int Box.Action

init : Int -> Int -> Model
init width height =
  { grid = initGrid width height
  , counter = 0
  }


initGrid : Int -> Int -> List (List (Int, Box.Model))
initGrid width height =
  List.map
    (\h -> initRow (h*width) width)
    [0..(height-1)]

initRow : Int -> Int -> List (Int, Box.Model)
initRow idOffset length =
  List.map
    (\a -> (idOffset + a, Box.init True))
    [0..(length-1)]

view : Signal.Address Action -> Model -> Html.Html
view address model =
  div []
    [ viewGrid address model.grid
    , button [ onClick address Decrement ] [ text "-" ]
    , div [] [ text (toString model.counter) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]

foo : Action
foo = Increment

viewGrid : Signal.Address Action -> List (List (Int, Box.Model)) -> Html.Html
viewGrid address grid =
  table []
    (List.map
        (viewRow address)
        grid)

viewRow : Signal.Address Action -> List (Int, Box.Model) -> Html.Html
viewRow address row =
  tr []
    (List.map
      (\(identifier, box) -> td [] [Box.view (Signal.forwardTo address (BoxAction identifier)) box])
      row)

-- update
increment : Model -> Model
increment model = { model | counter = model.counter - 1 }

decrement : Model -> Model
decrement model = { model | counter = model.counter + 1 }

updateGridItem : Int -> Box.Action -> Model -> Model
updateGridItem id action model =
  { model |
    grid = List.map
      (\row ->
        List.map
          (\(identifier, box) ->
            if identifier == id
            then (identifier, Box.update action box)
            else (identifier, box)
            )
          row)
      model.grid
  }
update : Action -> Model -> Model
update action model =
  case action of
    BoxAction identifier boxAction -> updateGridItem identifier boxAction model
    Increment -> decrement model
    Decrement -> increment model
