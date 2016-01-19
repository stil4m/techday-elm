module Main (..) where

import Html
import StartApp.Simple exposing (start)
import Now
import Game


main : Signal Html.Html
main =
    start
        { model = init
        , update = Game.update
        , view = Game.view
        }


init : Game.Model
init =
    Game.init Now.loadTime 10 10 10
