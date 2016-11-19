module App.State exposing (..)

import Navigation exposing (..)
import Routing exposing (..)
import App.Rest exposing (..)
import App.Types exposing (..)
import Dashboard.Rest as DRest exposing (fetchHeroes)
import Dashboard.State exposing (update, init)
import HeroDetail.State exposing (update, init)
import HeroesList.Rest as HLRest exposing (fetchHeroes)
import HeroesList.State exposing (update, init)


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of
        HeroDetail heroDetail ->
            let
                ( newModel, newCmd ) =
                    HeroDetail.State.update heroDetail model.heroDetailModel
            in
                { model | heroDetailModel = newModel } ! [ Cmd.map HeroDetail newCmd ]

        HeroesList heroesList ->
            let
                ( newModel, newCmd ) =
                    HeroesList.State.update heroesList model.heroesListModel
            in
                { model | heroesListModel = newModel } ! [ Cmd.map HeroesList newCmd ]

        DashboardT dashboard ->
            let
                ( newModel, newCmd ) =
                    Dashboard.State.update dashboard model.dashboardModel
            in
                { model | dashboardModel = newModel } ! [ Cmd.map DashboardT newCmd ]

        FetchHeroSucceed hero ->
            let
                heroDetailModel =
                    model.heroDetailModel
            in
                { model | heroDetailModel = { heroDetailModel | selectedHero = Just hero } } ! []

        FetchHeroFail message ->
            model ! []


urlUpdate : Result String Route -> AppModel -> ( AppModel, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        case currentRoute of
            HeroDetails id ->
                { model | route = currentRoute } ! [ fetchHero ("http://localhost:3000/heroes/" ++ toString id) ]

            Dashboard ->
                { model | route = currentRoute } ! [ Cmd.map DashboardT (DRest.fetchHeroes "http://localhost:3000/heroes") ]

            Heroes ->
                { model | route = currentRoute } ! [ Cmd.map HeroesList (HLRest.fetchHeroes "http://localhost:3000/heroes") ]

            other ->
                { model | route = other } ! []


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none


initApp : Route -> AppModel
initApp route =
    { title = "Tour of Heroes"
    , heroesList = []
    , route = route
    , heroDetailModel = fst HeroDetail.State.init
    , heroesListModel = fst HeroesList.State.init
    , dashboardModel = fst Dashboard.State.init
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
