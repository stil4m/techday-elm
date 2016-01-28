module CounterPair (update, view, model) where

import Html exposing (..)
import Counter

type alias Model =
    { top : Counter.Model
    , bottom : Counter.Model
    }


type Action
    = Bottom Counter.Action
    | Top Counter.Action


model : Model
model =
    { top = 0
    , bottom = 42
    }


view : Signal.Address Action -> Model -> Html
view address model =
    div [] [
      Counter.view (Signal.forwardTo address Top) model.top
      ,
      Counter.view (Signal.forwardTo address Bottom) model.bottom
    ]


update : Action -> Model -> Model
update action model =
    case action of
        Bottom a ->
            { model | bottom = Counter.update a model.bottom}

        Top a ->
            { model | top = Counter.update a model.top}
