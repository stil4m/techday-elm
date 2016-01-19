module Game (Model, init, view, update) where

import Grid exposing (markedBoxes)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Random exposing (initialSeed, Seed)


type alias Model =
    { seed : Seed
    , grid : Grid.Model
    , width : Int
    , height : Int
    , bombs : Int
    , bombsLeft : Int
    }


type Action
    = GridAction Grid.Action
    | Reset
    | NoOp


init : Int -> Int -> Int -> Int -> Model
init now width height bombs =
    let
        ( grid, seed ) = Grid.init (initialSeed now) width height bombs
    in
        { seed = seed
        , grid = grid
        , width = width
        , height = height
        , bombs = bombs
        , bombsLeft = bombs
        }


gameStyle : Attribute
gameStyle =
    style [ ( "margin", "20px auto" ), ( "width", "400px" ) ]


barStyle : Attribute
barStyle =
    style [ ( "padding", "10px 0 10px 0" ) ]


view : Signal.Address Action -> Model -> Html.Html
view address model =
    div
        [ gameStyle ]
        [ div
            [ barStyle ]
            [ button [ onClick address Reset ] [ text "Reset" ]
            , span [] [ text <| (++) " "<| toString model.bombsLeft]
            ]
        , Grid.view (Signal.forwardTo address GridAction) model.grid
        ]


reset : Model -> Model
reset model =
    let
        ( newGrid, newSeed ) = Grid.init model.seed model.width model.height model.bombs
    in
        { model | seed = newSeed, grid = newGrid, bombsLeft = model.bombs }


update : Action -> Model -> Model
update action model =
    case action of
        Reset ->
            reset model

        NoOp ->
            model

        GridAction a ->
            let
              newGrid = Grid.update a model.grid
              marked = markedBoxes newGrid
            in
              { model | grid = newGrid
                      , bombsLeft = model.bombs - marked}
