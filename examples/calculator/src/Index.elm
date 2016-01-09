module Index (..) where

import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, colspan, class)
import StartApp.Simple as StartApp
import Maybe exposing (withDefault, oneOf, andThen)


main : Signal Html.Html
main =
    StartApp.start { model = model, view = view, update = update }


type Operand
    = Multiply
    | Divide
    | Add
    | Minus
    | Assign
    | Decimal


type Action
    = NewNumber Int
    | Operation Operand


type alias Model =
    { value : Maybe Float
    , operand : Maybe Operand
    , previousOperation : Float -> Float
    , previousValue : Float
    , inDecimal : Bool
    }


model : Model
model =
    { value = Nothing
    , operand = Nothing
    , previousOperation = identity
    , previousValue = 0.0
    , inDecimal = False
    }


view : Signal.Address Action -> Model -> Html.Html
view address model =
    div
        [ class "app" ]
        [ screen model
        , div
            [ class "buttons-container" ]
            [ numberButton 7 address
            , numberButton 8 address
            , numberButton 9 address
            , operandButton Multiply "*" address
            , numberButton 4 address
            , numberButton 5 address
            , numberButton 6 address
            , operandButton Divide "/" address
            , numberButton 1 address
            , numberButton 2 address
            , numberButton 3 address
            , operandButton Minus "-" address
            , operandButton Decimal "." address
            , numberButton 0 address
            , operandButton Assign "=" address
            , operandButton Add "+" address
            ]
        ]


screenValue : Model -> String
screenValue m =
    toString (withDefault m.previousValue m.value)


screen : Model -> Html.Html
screen m =
    div [ class "screen" ] [ text (screenValue m) ]


operandButton : Operand -> String -> Signal.Address Action -> Html.Html
operandButton operand op =
    basicButton (Operation operand) op


numberButton : Int -> Signal.Address Action -> Html.Html
numberButton v =
    basicButton (NewNumber v) (toString v)


basicButton : Action -> String -> Signal.Address Action -> Html.Html
basicButton act t addr =
    div
        [ class "action-button" ]
        [ button [ onClick addr act ] [ text t ] ]


handleNewNumber : Int -> Model -> Model
handleNewNumber x m =
    case m.value of
        Nothing ->
            { m | value = Just (toFloat x) }

        Just y ->
            { m | value = Just (toFloat x + y * 10) }


asOperation : Float -> Operand -> Float -> Float
asOperation x o =
    let
        binary =
            (case o of
                Add ->
                    (+)

                Minus ->
                    (-)

                Multiply ->
                    (*)

                Divide ->
                    (/)

                _ ->
                    always identity
            )
    in
        flip binary x


nextOperation : Model -> Float -> Float
nextOperation m =
    withDefault
        m.previousOperation
        (oneOf
            [ Maybe.map2 asOperation m.value m.operand
            , Maybe.map (asOperation m.previousValue) m.operand
            ]
        )


handleOperand : Operand -> Model -> Model
handleOperand o m =
    case o of
        Assign ->
            let
                n = (nextOperation m)
            in
                { m
                    | value = Nothing
                    , operand = Nothing
                    , previousValue = n m.previousValue
                    , previousOperation = n
                }

        x ->
            let
                previousValue =
                    withDefault
                        (withDefault m.previousValue m.value)
                        (Maybe.map
                            (\f -> f m.previousValue)
                            (Maybe.map2 asOperation m.value m.operand)
                        )
            in
                { m
                    | previousValue = previousValue
                    , value = Nothing
                    , operand = Just x
                }


update : Action -> Model -> Model
update action model =
    case action of
        NewNumber x ->
            handleNewNumber x model

        Operation o ->
            handleOperand o model
