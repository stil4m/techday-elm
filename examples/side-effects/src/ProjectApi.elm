module ProjectApi (getProjects, Project) where

import Effects exposing (Effects)
import Http
import Json.Decode as Json exposing ((:=))
import Task

getProjects : ((Maybe (List Project)) -> a) -> Effects a
getProjects f =
    Http.get projects "http://localhost:8000/projects.json"
        |> Task.toMaybe
        |> Task.map f
        |> Effects.task

type alias Project = { key : String, name : String}

projects : Json.Decoder (List Project)
projects = Json.list project

project : Json.Decoder Project
project = Json.object2 Project
    ("key" := Json.string)
    ("name" := Json.string)
