module Main (..) where

import Graphics.Element exposing (..)
import Keyboard
import Html exposing (div)
import Html.Attributes exposing (style)


main : Signal Html.Html
main =
    (Signal.map render model)


type alias Location =
    { x : Int, y : Int }


render : Location -> Html.Html
render m =
    div
        [ style [ ( "position", "relative" ) ] ]
        [ box m.x m.y ]


model : Signal { x : Int, y : Int }
model =
    Signal.foldp handleArrow { x = 0, y = 0 } Keyboard.arrows


handleArrow : Location -> Location -> Location
handleArrow a b =
    { x = a.x + b.x, y = negate a.y + b.y }


box : Int -> Int -> Html.Html
box x y =
    div
        [ style
            [ ( "width", "50px" )
            , ( "height", "50px" )
            , ( "position", "absolute" )
            , ( "background", "blue" )
            , ( "left", toString (x * 50) ++ "px" )
            , ( "top", toString (y * 50) ++ "px" )
            ]
        ]
        []
