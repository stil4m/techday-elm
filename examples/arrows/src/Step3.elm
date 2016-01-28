module Step3 (..) where

import Html exposing (text)
import Keyboard



type alias Location =
    { x : Int, y : Int }


main : Signal Html.Html
main =
    Signal.map (\x -> toString x |> text) boxPosition


boxPosition : Signal Location
boxPosition =
    Signal.foldp handleArrow { x = 0, y = 0 } Keyboard.arrows


handleArrow : Location -> Location -> Location
handleArrow arrows old =
    { x = old.x + arrows.x
    , y = old.y + (negate arrows.y)
    }
