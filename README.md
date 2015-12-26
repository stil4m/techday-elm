# Resources

* Performance: thehttp://elm-lang.org/blog/blazing-fast-html

# Important
 * This means no one can rely on implementation details that were not made public (https://github.com/evancz/elm-architecture-tutorial/)
 
 
# First Program
### Setup

File in `src/Index.elm`

```
import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp


main =
  StartApp.start { model = model, view = view, update = update }


model = 0


view address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , button [ onClick address Increment ] [ text "+" ]
    , div [] [ text (toString model) ]
    ]


type Action = Increment | Decrement


update action model =
  case action of
    Increment -> model + 1
    Decrement -> model - 1
```

---

### Run

`elm package install`

Installs the required package elm-core.

```
elm package install evancz/elm-html
elm package install evancz/start-app
```

Install dependencies

`elm-reactor`

Starts a webserver and compiles elm on the fly

