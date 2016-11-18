module App exposing (..)

import App.Types exposing (..)
import App.Rest exposing (..)
import Routing exposing (..)
import Navigation exposing (..)
import String exposing (..)
import HeroDetail.State exposing (..)
import App.View exposing (..)
import App.State exposing (..)


initApp : Route -> AppModel
initApp route =
    { title = "Tour of Heroes"
    , heroesList = []
    , route = route
    , searchBox = Nothing
    , heroDetailModel = fst HeroDetail.State.init
    , newHeroName = Nothing
    }


init : Result String Route -> ( AppModel, Cmd Msg )
init result =
    let
        currentRoute =
            Routing.routeFromResult result

        url =
            "http://localhost:3000/heroes"
    in
        ( initApp currentRoute, newUrl "#dashboard" )


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , view = App.View.root
        , update = App.State.update
        , subscriptions = subscriptions
        , urlUpdate = urlUpdate
        }
