module CounterPair (update,view,model) where

import Html exposing (..)

type alias Model = String

type Action = TODO

model : Model
model = "S"

view : Signal.Address Action -> Model -> Html
view address model = div [] []

update : Action -> Model -> Model
update action model = model
