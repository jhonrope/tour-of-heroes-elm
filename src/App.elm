module App exposing (..)

import Navigation exposing (program)
import App.View exposing (root)
import App.State exposing (update, init, subscriptions, urlUpdate)
import Routing exposing (parser)


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , view = App.View.root
        , update = App.State.update
        , subscriptions = subscriptions
        , urlUpdate = urlUpdate
        }
