module Box (Model, Action, init, makeMine, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Utils exposing (onRightClick)

type alias Model =
  { isMine : Bool
  , isOpened : Bool
  , isMarked : Bool
  }

type Action = Reveal | Mark

init : Bool -> Model
init isMine =
  { isMine = isMine
  , isOpened = False
  , isMarked = False
  }

makeMine : Model -> Model
makeMine model =
  { model |
    isMine = True
  }

reveal : Model -> Model
reveal model =
  if model.isMarked
    then
      model
    else
      { model |
        isOpened = True
      }

mark : Model -> Model
mark model =
  { model |
    isMarked = not model.isMarked
  }

update : Action -> Model -> Model
update action model =
  case action of
    Reveal ->
      reveal model
    Mark ->
      mark model

baseBox : List (String, String)
baseBox =
  [ ("border", "1px solid gray")
  , ("border-radius", "5px")
  , ("width", "20px")
  , ("height", "20px")
  ]

bombBox : List(String, String)
bombBox =
  [ ("text-align", "center")
  ]
  ++ baseBox
markedBox : List (String, String)
markedBox =
  [ ("background", "gray")]
  ++
  baseBox

view : Signal.Address Action -> Model -> Html
view address model =
  if model.isOpened
    then
      if model.isMine
        then
          div [ attribute "class" "tile", style bombBox ]
          [ img [ attribute "src" "http://vignette2.wikia.nocookie.net/tibia/images/a/a5/Ultimate_Explosion.gif/revision/latest?cb=20050528232132&path-prefix=en"
                , attribute "width" "18"
                , attribute "height" "18"
                ]
                []]
        else
          div [ attribute "class" "tile", style baseBox ] [ text << toString <| model.isMine ]
    else if  model.isMarked then
        div [ class "tile marked"
            , style markedBox
            , onClick address Reveal
            , onRightClick address Mark
            ] [text ""]
     else
       div [ class "tile"
            , style baseBox
            , onClick address Reveal
            , onRightClick address Mark
            ]
            [ ]
