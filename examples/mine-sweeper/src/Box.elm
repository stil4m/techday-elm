module Box (BoxType, Model, Action, isEmpty, initWithHint, initAsEmpty, initAsMine, revealAction, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Utils exposing (onRightClick)


type BoxType
    = Mine
    | Hint Int
    | Empty


type alias Model =
    { form : BoxType
    , isOpened : Bool
    , isMarked : Bool
    }


type Action
    = Reveal
    | Mark


isEmpty : Model -> Bool
isEmpty m =
    m.isOpened && m.form == Empty


revealAction : Action
revealAction =
    Reveal


init : BoxType -> Model
init f =
    { form = f
    , isOpened = False
    , isMarked = False
    }


initWithHint : Int -> Model
initWithHint h =
    init (Hint h)


initAsEmpty : Model
initAsEmpty =
    init Empty


initAsMine : Model
initAsMine =
    init Mine


reveal : Model -> Model
reveal model =
    if model.isMarked || model.isOpened then
        model
    else
        { model
            | isOpened = True
        }


mark : Model -> Model
mark model =
    { model | isMarked = not model.isMarked }


update : Action -> Model -> Model
update action model =
    case action of
        Reveal ->
            reveal model

        Mark ->
            mark model


baseBox : List ( String, String )
baseBox =
    [ ( "border", "1px solid gray" )
    , ( "width", "20px" )
    , ( "height", "20px" )
    , ( "font-weight", "bold")
    , ( "text-align", "center" )
    ]

hintBoxStyle : Int -> List (String, String)
hintBoxStyle x =
    (case x of
      1 -> ("color", "blue")
      2 -> ("color", "green")
      3 -> ("color", "red")
      _ -> ("color", "gray"))
    :: baseBox


emptyBox : List ( String, String )
emptyBox =
    ( "background", "#eee" ) :: baseBox


bombBox : List ( String, String )
bombBox =
    [ ( "text-align", "center" ) ]
        ++ baseBox


markedBox : List ( String, String )
markedBox =
    [ ( "background", "gray" ) ]
        ++ baseBox


view : Signal.Address Action -> Model -> Html
view address model =
    case model.isOpened of
        True ->
            case model.form of
                Mine ->
                    viewMine

                Hint x ->
                    viewHint x

                Empty ->
                    viewEmpty

        False ->
            case model.isMarked of
                True ->
                    viewMarked address

                False ->
                    viewUnknown address


viewMine : Html.Html
viewMine =
    div
        [ attribute "class" "tile", style bombBox ]
        [ img
            [ attribute "src" "http://vignette2.wikia.nocookie.net/tibia/images/a/a5/Ultimate_Explosion.gif/revision/latest?cb=20050528232132&path-prefix=en"
            , attribute "width" "18"
            , attribute "height" "18"
            ]
            []
        ]


viewHint : Int -> Html.Html
viewHint x =
    div [ attribute "class" "tile", style (hintBoxStyle x) ] [ text << toString <| x ]


viewEmpty : Html.Html
viewEmpty =
    div [ attribute "class" "tile", style emptyBox ] []


viewMarked : Signal.Address Action -> Html.Html
viewMarked address =
    div
        [ class "tile marked"
        , style markedBox
        , onClick address Reveal
        , onRightClick address Mark
        ]
        [ text "" ]


viewUnknown : Signal.Address Action -> Html.Html
viewUnknown address =
    div
        [ class "tile"
        , style baseBox
        , onClick address Reveal
        , onRightClick address Mark
        ]
        []
