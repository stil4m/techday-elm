module Grid (Model, GridRow, Action, init, update, view) where

import Box
import Html exposing (table, tr, td)

type alias Tile =
  { id : Int
  , box : Box.Model
  }

type alias GridRow = List Tile
type alias Model = List GridRow
type Action = BoxAction Int Box.Action

init : Int -> Int -> Model
init width height =
  List.map
    (\h -> initRow (h*width) width)
    [0..(height-1)]

initRow : Int -> Int -> GridRow
initRow idOffset length =
  List.map
    (\a -> Tile (idOffset + a) (Box.init True))
    [0..(length-1)]

view : Signal.Address Action -> Model -> Html.Html
view address grid =
  table []
    (List.map
        (viewRow address)
        grid)

viewRow : Signal.Address Action -> GridRow -> Html.Html
viewRow address row =
  tr []
    (List.map
      (\tile -> td [] [Box.view (Signal.forwardTo address (BoxAction tile.id)) tile.box])
      row)


updateTile : Int -> Box.Action -> Tile -> Tile
updateTile id action tile =
  if
    tile.id == id
  then
    (Tile tile.id (Box.update action tile.box))
  else
    tile


update : Action -> Model -> Model
update action model =
  case action of
    BoxAction id act ->
      List.map
        (\row ->
          List.map
            (updateTile id act)
            row)
        model
