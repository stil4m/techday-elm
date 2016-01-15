module CounterPair (update,view,model) where

import Html exposing (..)

type alias Model = {}

type Action = TODO

model : Model
model = {}

view : Signal.Address Action -> Model -> Html
view address model = div [] []

update : Action -> Model -> Model
update action model = model
