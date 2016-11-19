module HeroesList.State exposing (..)

import HeroesList.Types exposing (..)
import Navigation exposing (..)
import HeroDetail.State exposing (..)
import App.Rest exposing (..)
import Hero.Types exposing (..)
import HeroesList.Rest exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        model =
            { newHeroName = Nothing
            , selectedHero = Nothing
            , heroesList = []
            }
    in
        model ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateNewHeroName newName ->
            { model | newHeroName = Just newName } ! []

        SelectHero hero ->
            { model | selectedHero = Just hero } ! []

        ViewDetails hero ->
            { model | selectedHero = Nothing } ! [ newUrl <| "#heroes/" ++ toString hero.id ]

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
            in
                { model | heroesList = newList, newHeroName = Nothing } ! []

        SaveHeroFail message ->
            model ! []

        DeleteHero hero ->
            model ! [ deleteHero <| "http://localhost:3000/heroes/" ++ toString hero.id ]

        DeleteHeroSucceed hero ->
            { model | newHeroName = Nothing } ! [ newUrl "#heroes" ]

        DeleteHeroFail message ->
            { model | newHeroName = Nothing } ! []

        FetchSucceed list ->
            { model | heroesList = list } ! []

        FetchFail message ->
            { model | heroesList = [] } ! []
