module Main (..) where

import Html exposing (table, tr, td, div, button, text)
import StartApp as StartApp
import Effects exposing (Effects)
import Now
import Grid


-- import Html.Events exposing (onClick)


app : StartApp.App Model
app =
    StartApp.start
        { init = ( init, Effects.none )
        , view = view
        , update = update
        , inputs = []
        }


main : Signal Html.Html
main =
    app.html


type alias Model =
    { grid : Grid.Model
    }


type Action
    = GridAction Grid.Action


init : Model
init =
    { grid = Grid.init Now.loadTime 10 10 10 }


view : Signal.Address Action -> Model -> Html.Html
view address model =
    Grid.view (Signal.forwardTo address GridAction) model.grid



-- update


update : Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        GridAction a ->
            let
                ( gridModel, gridEffects ) = Grid.update a model.grid
            in
                ( { model | grid = gridModel }, Effects.map GridAction gridEffects )
