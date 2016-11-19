module App.State exposing (..)

import App.Types exposing (..)
import HeroDetail.State exposing (..)
import Navigation exposing (..)
import App.Rest exposing (..)
import Routing exposing (..)
import HeroesList.State exposing (..)
import Dashboard.State exposing (..)


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

        FetchSucceed list ->
            { model | heroesList = list } ! []

        FetchFail message ->
            { model | heroesList = [] } ! []

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
                { model | route = currentRoute } ! [ fetchHero ("http://localhost:3000/heroes/" ++ (toString id)) ]

            Dashboard ->
                { model | route = currentRoute } ! [ fetchHeroes "http://localhost:3000/heroes" ]

            Heroes ->
                { model | route = currentRoute } ! [ fetchHeroes "http://localhost:3000/heroes" ]

            other ->
                { model | route = other } ! []
