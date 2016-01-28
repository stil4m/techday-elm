module Step4 (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Keyboard


type alias Location =
    { x : Int, y : Int }


main : Signal Html.Html
main =
    Signal.map view boxPosition


boxPosition : Signal Location
boxPosition =
    Signal.foldp handleArrow { x = 0, y = 0 } Keyboard.arrows


handleArrow : Location -> Location -> Location
handleArrow arrows old =
    { x = old.x + arrows.x
    , y = old.y + (negate arrows.y)
    }


view : Location -> Html.Html
view loc =
    div
        [ style (boxStyle loc) ]
        []


boxStyle : Location -> List ( String, String )
boxStyle location =
    [ ( "position", "absolute" )
    , ( "background", "blue" )
    , ( "width", "50px" )
    , ( "height", "50px" )
    ]
