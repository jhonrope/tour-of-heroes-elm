module App.State exposing (..)

import App.Types exposing (..)
import HeroDetail.State exposing (..)
import Navigation exposing (..)
import App.Rest exposing (..)
import Hero.Types exposing (..)
import Routing exposing (..)


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of
        HeroDetail heroDetail ->
            let
                ( newModel, newCmd ) =
                    HeroDetail.State.update heroDetail model.heroDetailModel
            in
                { model | heroDetailModel = newModel } ! [ Cmd.map HeroDetail newCmd ]

        UpdateNewHeroName newName ->
            { model | newHeroName = Just newName } ! []

        SelectHero hero ->
            let
                heroDetailModel =
                    model.heroDetailModel
            in
                { model | heroDetailModel = { heroDetailModel | selectedHero = Just hero } } ! []

        ViewDetails hero ->
            { model | heroDetailModel = fst HeroDetail.State.init, searchBox = Nothing } ! [ newUrl <| "#heroes/" ++ toString hero.id ]

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

        DeleteHero hero ->
            model ! [ deleteHero <| "http://localhost:3000/heroes/" ++ toString hero.id ]

        DeleteHeroSucceed hero ->
            { model | heroDetailModel = fst HeroDetail.State.init } ! [ newUrl "#heroes" ]

        DeleteHeroFail message ->
            { model | heroDetailModel = fst HeroDetail.State.init } ! []

        SaveHero ->
            case model.newHeroName of
                Just newName ->
                    { model | newHeroName = Nothing } ! [ saveHero (Hero 0 newName) "http://localhost:3000/heroes" ]

                Nothing ->
                    model ! []

        SaveHeroSucceed hero ->
            let
                newList =
                    model.heroesList ++ [ hero ]

                heroDetailModel =
                    model.heroDetailModel
            in
                { model | heroesList = newList, heroDetailModel = fst HeroDetail.State.init } ! []

        SaveHeroFail message ->
            model ! []

        UpdateSearchBox string ->
            if string == "" then
                { model | searchBox = Nothing } ! []
            else
                { model | searchBox = Just string } ! []


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
                { model | route = currentRoute, searchBox = Nothing } ! [ fetchHeroes "http://localhost:3000/heroes" ]

            Heroes ->
                { model | route = currentRoute, searchBox = Nothing } ! [ fetchHeroes "http://localhost:3000/heroes" ]

            other ->
                { model | route = other, searchBox = Nothing } ! []
