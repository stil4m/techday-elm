module Main (..) where

import Graphics.Element exposing (..)
import Signal exposing (Signal)
import ElmTest exposing (consoleRunner, elementRunner)
import Console exposing (IO, run)
-- import Task
import Tests
-- import Mouse

console : IO ()
console =
    consoleRunner Tests.all

main : Signal Element
main = Signal.constant (elementRunner Tests.all)
    -- Signal.map show Mouse.position

-- port runner : Signal (Task.Task x ())
-- port runner =
    -- run console
