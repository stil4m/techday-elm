module Index (..) where

import Html exposing (..)
import Signal exposing (Signal, Address)
import Html.Shorthand exposing (..)
import Bootstrap.Html exposing (..)
import Maybe exposing (withDefault)


type alias Model =
    { users : List User
    }


initialModel : Model
initialModel =
    { users = []
    }


port addUser : Signal (Maybe User)
port userCount : Signal Int
port userCount =
    Signal.map List.length <| Signal.map .users model


type alias User =
    { name : String, age : Int }


type Action
    = NoOp
    | NewUser User


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
            [ userHeader [ "Name", "Age" ]
            , userBody model.users
            ]
        ]


userHeader : List String -> Html
userHeader hs =
    thead_ [ tr_ (List.map (\h -> th_ [ text h ]) hs) ]


userBody : List User -> Html
userBody users =
    tbody_ (renderUsers users)


renderUsers : List User -> List Html
renderUsers users =
    List.map renderUser users


renderUser : User -> Html
renderUser user =
    tr_ [ renderCol user.name, renderCol user.age ]


renderCol : a -> Html
renderCol a =
    td_ [ (text (toString a)) ]


main : Signal Html
main =
    Signal.map (view actionMailbox.address) model


model : Signal Model
model =
    Signal.merge actionMailbox.signal onAddUser
        |> Signal.foldp update initialModel


actionMailbox : Signal.Mailbox Action
actionMailbox =
    Signal.mailbox NoOp


onAddUser : Signal Action
onAddUser =
    Signal.map (Maybe.map NewUser >> withDefault NoOp) addUser
