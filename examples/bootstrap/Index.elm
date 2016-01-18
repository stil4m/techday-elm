module Index (..) where

import Html exposing (..)
import Signal exposing (Signal, Address)
import Html.Shorthand exposing (..)
import Bootstrap.Html exposing (..)
import Maybe exposing (withDefault)


type alias Model =
    { users : List UserRecord
    }


initialModel : Model
initialModel =
    { users = []
    }


port addUser : Signal (Maybe UserRecord)

port userCount : Signal Int
port userCount =
  Signal.map List.length (Signal.map .users model)

type alias UserRecord =
    { name : String, age : Int }


type Action
    = NoOp
    | NewUser UserRecord


update : Action -> Model -> Model
update action model =
    case action of
        NoOp ->
            model

        NewUser x ->
            { model | users = x :: model.users }


view : Address Action -> Model -> Html
view actions model =
    div_
        [ h1 [] [ text "Elm Content" ]
        , tableStriped_
            [ thead_ [ tr_ [ th_ [ text "Name" ], th_ [ text "Age" ] ] ]
            , tbody_ (renderUsers model.users)
            ]
        ]


renderUsers : List UserRecord -> List Html
renderUsers users =
    List.map renderUser users


renderUser : UserRecord -> Html
renderUser user =
    tr_
        [ td_ [ (text user.name) ]
        , td_ [ (user.age |> toString >> text) ]
        ]


main : Signal Html
main =
    Signal.map (view actionMailbox.address) model


model : Signal Model
model =
    (Signal.foldp update initialModel (Signal.merge actionMailbox.signal onAddUser))


actionMailbox : Signal.Mailbox Action
actionMailbox =
    Signal.mailbox NoOp


onAddUser : Signal Action
onAddUser =
    Signal.map (Maybe.map NewUser >> withDefault NoOp) addUser
