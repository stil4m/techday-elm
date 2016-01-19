module Grid (Model, GridRow, Action, init, update, view, markedBoxes) where

import Html exposing (table, tr, td, text)
import Html.Attributes exposing (style)
import GridUtil exposing (getPositions, BoxState, Position)
import Box exposing (BoxType, isEmpty)
import Random exposing (Seed)


type alias Tile =
    { id : Position
    , box : Box.Model
    }


type alias GridRow =
    List Tile


type alias Model =
    List GridRow


type Action
    = BoxAction Position Box.Action

markedBoxes : Model -> Int
markedBoxes m = List.sum (List.map (\row -> List.length (List.filter isMarked row)) m)

isMarked : Tile -> Bool
isMarked tile = tile.box.isMarked

init : Seed -> Int -> Int -> Int -> ( Model, Seed )
init seed width height bombs =
    let
        ( positions, newSeed ) = getPositions seed width height bombs
    in
        ( List.map initRow (locationsToRows height <| positions), newSeed )


locationsToRows : Int -> List ( Position, BoxState ) -> List (List ( Position, BoxState ))
locationsToRows height locations =
    List.map (\x -> (fst (List.partition (fst >> fst >> (==) x) locations))) [0..(height - 1)]


initRow : List ( Position, BoxState ) -> GridRow
initRow positions =
    List.map
        (\( pos, boxState ) -> Tile pos (initBox boxState))
        positions


initBox : BoxState -> Box.Model
initBox boxState =
    case boxState of
        -1 ->
            Box.initAsMine

        0 ->
            Box.initAsEmpty

        hint ->
            Box.initWithHint hint


view : Signal.Address Action -> Model -> Html.Html
view address grid =
    table
        [ style
            [ ( "border-collapse", "collapse" )
            , ( "border", "1px solid gray" )
            ]
        ]
        (List.map (viewRow address) grid)


viewRow : Signal.Address Action -> GridRow -> Html.Html
viewRow address row =
    tr
        []
        (List.map (viewTile address) row)


viewTile : Signal.Address Action -> Tile -> Html.Html
viewTile address tile =
    td
        [ style [ ( "padding", "0" ) ] ]
        [ Box.view (Signal.forwardTo address (BoxAction tile.id)) tile.box ]


mapAllTiles : (Tile -> ( Tile, List Action )) -> Model -> ( Model, List Action )
mapAllTiles f rows =
    let
        ( newRows, effects ) = List.unzip (List.map (mapAllRowTiles f) rows)
    in
        ( newRows, List.concat effects )


mapAllRowTiles : (Tile -> ( Tile, List Action )) -> GridRow -> ( GridRow, List Action )
mapAllRowTiles f row =
    let
        ( rowTiles, effects ) = List.unzip (List.map f row)
    in
        ( rowTiles, List.concat effects )


updateTile : Position -> Box.Action -> Tile -> ( Tile, List Action )
updateTile id a tile =
    if tile.id /= id then
        ( tile, [] )
    else
        let
            newTile = { tile | box = (Box.update a tile.box) }
        in
            if not tile.box.isOpened && Box.isEmpty newTile.box then
                ( newTile, List.map (\x -> BoxAction x Box.revealAction) (surroundingTiles id) )
            else
                ( newTile, [] )


surroundingTiles : Position -> List Position
surroundingTiles position =
    let
        ( x, y ) = position

        square = List.concatMap (\x -> List.map ((,) x) [ y - 1, y, y + 1 ]) [ x - 1, x, x + 1 ]
    in
        List.filter ((/=) position) square


update : Action -> Model -> Model
update action model =
    case action of
        BoxAction id boxAction ->
            let
                ( newModel, additionalChanges ) = mapAllTiles (updateTile id boxAction) model
                newModelRec = List.foldl update newModel additionalChanges
            in
                newModelRec
