module Main (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp
import Effects exposing (Never, Effects)
import ProjectApi exposing (getProjects, Project)
import Task


main : Signal Html.Html
main =
    app.html


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks


app : StartApp.App Model
app =
    StartApp.start
        { init = init
        , update = update
        , view = view
        , inputs = []
        }


type Action
    = Increment
    | Decrement
    | AllProjects (Maybe (List Project))


type alias Model =
    { counter : Int
    , projects : Maybe (List Project)
    , gotAll : Bool
    }


init : ( Model, Effects Action )
init =
    ( { counter = 1, projects = Nothing, gotAll = False }
    , getProjects (\x -> AllProjects x)
    )


view : Signal.Address Action -> Model -> Html.Html
view address model =
    div
        []
        [ button [ onClick address Decrement ] [ text "-" ]
        , div [] [ text (toString model) ]
        , button [ onClick address Increment ] [ text "+" ]
        , Maybe.withDefault noProjects (Maybe.map projectsList model.projects)
        ]


noProjects : Html.Html
noProjects =
    div
        []
        [ em [] [ text "We could not load any projects!" ] ]


projectsList : List Project -> Html.Html
projectsList projects =
    ul
        []
        (List.map projectItem projects)


projectItem : Project -> Html.Html
projectItem project =
    li
        []
        [ text (project.name ++ " (" ++ project.key ++ ")") ]


update : Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        Increment ->
            ( { model | counter = model.counter + 1 }, Effects.none )

        Decrement ->
            ( { model | counter = model.counter - 1 }, Effects.none )

        AllProjects x ->
            ( { model | projects = x, gotAll = True }, Effects.none )
