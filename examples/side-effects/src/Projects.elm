module Projects (init, update, view, Model, Action) where

import Effects exposing (Effects)
import Http
import Json.Decode as Json exposing ((:=), maybe)
import Task exposing (Task)
import Html exposing (..)
import Html.Attributes exposing (style)
import Effects exposing (Never, Effects)
import Result


type Action
    = FetchedProjects Projects


type alias Model =
    Projects


type Projects
    = Loading
    | Error String
    | Success (List Project)


type alias Project =
    { key : String
    , name : String
    , lead : Maybe String
  }


init : ( Model, Effects Action )
init =
    ( Loading
    , Effects.map FetchedProjects getProjects
    )


view : Signal.Address Action -> Model -> Html.Html
view address model =
    case model of
        Loading ->
            loadingProjects

        Error s ->
            projectsErrorAlert s

        Success projects ->
            projectsList projects


loadingProjects : Html.Html
loadingProjects =
    div [] [ em [] [ text "Loading projects..." ] ]


projectsErrorAlert : String -> Html.Html
projectsErrorAlert s =
    div
        [ style [ ( "color", "red" ) ] ]
        [ em [] [ text ("We could not load projects: " ++ s) ] ]


projectsList : List Project -> Html.Html
projectsList projects =
    ul
        []
        (List.map projectItem projects)


projectItem : Project -> Html.Html
projectItem project =
    li
        []
        [ text (project.name ++ " (" ++ project.key ++ "/" ++ (toLead project.lead) ++ ")") ]


toLead : Maybe String -> String
toLead =
    Maybe.withDefault "UNKNOWN"


update : Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        FetchedProjects x ->
            ( x, Effects.none )



{- Fetch projects -}


getProjects : Effects Projects
getProjects =
    delayFetch
        |> Task.toResult
        |> Task.map toListOrError
        |> Effects.task


delayFetch : Task Http.Error (List Project)
delayFetch =
    Task.andThen (Task.sleep 0) (\_ -> fetch)


toListOrError : Result Http.Error (List Project) -> Projects
toListOrError x =
    case x of
        Err s ->
            Error (toString s)

        Ok projects ->
            Success projects


fetch : Task Http.Error (List Project)
fetch =
    Http.get projects "http://localhost:8000/projects.json"


projects : Json.Decoder (List Project)
projects =
    Json.list project


project : Json.Decoder Project
project =
    Json.object3
        Project
        ("key" := Json.string)
        ("name" := Json.string)
        (maybe ("lead" := Json.string))
