module Grid (Model, GridRow, Action, init, update, view) where

import Box
import Html exposing (table, tr, td)
import Effects exposing (Effects)
import Random exposing (Seed, initialSeed)


type alias Tile =
    { id : Int
    , box : Box.Model
    }


type alias GridRow =
    List Tile


type alias Model =
    List GridRow


type Action
    = BoxAction Int Box.Action
    | SeedRequest


init : Int -> Int -> Int -> Int -> ( Model, Effects Action )
init now width height bombs =
    let
        ( s, shuffled ) = shuffle (initialSeed now) (width * height)

        posses = List.take bombs shuffled
    in
        ( List.map
            (\h -> initRow posses (h * width) width)
            [0..(height - 1)]
        , requestSeed
        )


requestSeed : Effects Action
requestSeed =
    Effects.none


shuffle : Seed -> Int -> ( Seed, List Int )
shuffle seed n =
    let
        numbers = [0..(n - 1)]

        ( newSeed, result ) =
            List.foldl
                (\a ( s, xs ) ->
                    let
                        ( v, ns ) = Random.generate (Random.float 0 1) s
                    in
                        ( ns, ( v, a ) :: xs )
                )
                ( seed, [] )
                numbers
    in
        ( newSeed
        , List.map snd (List.sortBy fst result)
        )


initRow : List Int -> Int -> Int -> GridRow
initRow bombPositions idOffset length =
    List.map
        (\a -> Tile (idOffset + a) (Box.init (List.member (idOffset + a) bombPositions)))
        [0..(length - 1)]


view : Signal.Address Action -> Model -> Html.Html
view address grid =
    table
        []
        (List.map
            (viewRow address)
            grid
        )


viewRow : Signal.Address Action -> GridRow -> Html.Html
viewRow address row =
    tr
        []
        (List.map
            (\tile -> td [] [ Box.view (Signal.forwardTo address (BoxAction tile.id)) tile.box ])
            row
        )


updateTile : Int -> Box.Action -> Tile -> Tile
updateTile id action tile =
    if
        tile.id == id
    then
        (Tile tile.id (Box.update action tile.box))
    else
        tile


update : Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        BoxAction id act ->
            ( List.map
                (\row ->
                    List.map
                        (updateTile id act)
                        row
                )
                model
            , Effects.none
            )

        SeedRequest ->
            ( model, Effects.none )
