module Step2 (..) where

import Html exposing (text)
import Keyboard


main : Signal Html.Html
main =
    Signal.map (\x -> toString x |> text) Keyboard.arrows
