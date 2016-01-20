module Index (..) where

import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp


main : Signal Html.Html
main =
    StartApp.start { model = 0, view = view, update = update }


type Action
    = Increment
    | Decrement


view : Signal.Address Action -> Int -> Html.Html
view address model =
    div
        []
        [ button [ onClick address Decrement ] [ text "-" ]
        , div [] [ text (toString model) ]
        , button [ onClick address Increment ] [ text "+" ]
        ]


update : Action -> Int -> Int
update action model =
    case action of
        Increment ->
            model + 1

        Decrement ->
            model - 1
