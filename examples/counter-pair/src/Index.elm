module Index (..) where

import CounterPair exposing (update, view)
import StartApp.Simple exposing (start)
import Html

main : Signal Html.Html
main =
    start
        { model = CounterPair.model
        , update = CounterPair.update
        , view = CounterPair.view
        }
