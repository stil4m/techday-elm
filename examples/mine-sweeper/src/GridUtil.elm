module GridUtil (getPositions, BoxState, Position) where

import Random exposing (initialSeed, Seed)


type alias BoxState =
    Int


type alias Position =
    ( Int, Int )


getPositions : Seed -> Int -> Int -> Int -> (List ( Position, BoxState ), Seed)
getPositions seed width height bombs =
    let
        numbers = [0..((width * height) - 1)]

        allPositions = List.map (indexToPosition width) numbers

        ( newSeed, shuffled ) = shuffle seed allPositions

        bombPosses = List.take bombs shuffled
    in
        (List.map (asPosition bombPosses) allPositions, newSeed)


indexToPosition : Int -> Int -> Position
indexToPosition width x =
    ( x // width, x % width )


asPosition : List Position -> Position -> ( Position, BoxState )
asPosition bombs item =
    if List.member item bombs then
        ( item, -1 )
    else
        let
            surrounding = isSurroundedBox item

            c = List.length <| List.filter surrounding bombs
        in
            ( item, c )


isSurroundedBox : Position -> Position -> Bool
isSurroundedBox ( x, y ) (x', y') = (x' >= x - 1) && (x' <= x + 1) && (y' >= y - 1) && (y' <= y + 1)


shuffle : Seed -> List a -> ( Seed, List a )
shuffle seed x =
    let
        ( newSeed, result ) =
            List.foldl
                (\a ( s, xs ) ->
                    let
                        ( v, ns ) = Random.generate (Random.float 0 1) s
                    in
                        ( ns, ( v, a ) :: xs )
                )
                ( seed, [] )
                x
    in
        ( newSeed
        , List.map snd (List.sortBy fst result)
        )
