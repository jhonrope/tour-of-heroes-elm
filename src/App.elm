module App exposing (..)

import Navigation exposing (..)
import App.View exposing (..)
import App.State exposing (..)
import App.Types exposing (..)
import Routing exposing (..)


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , view = App.View.root
        , update = App.State.update
        , subscriptions = subscriptions
        , urlUpdate = urlUpdate
        }
