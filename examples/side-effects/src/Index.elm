module Index (..) where

import StartApp
import Task
import Effects exposing (Never)
import Projects
import Html


main : Signal Html.Html
main =
    app.html


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks


app : StartApp.App Projects.Model
app =
    StartApp.start
        { init = Projects.init
        , update = Projects.update
        , view = Projects.view
        , inputs = []
        }
