module HeroSearch.State exposing (..)

import Navigation exposing (newUrl)
import Hero.Types exposing (..)
import HeroSearch.Types exposing (..)


init : List Hero -> ( Model, Cmd Msg )
init list =
    let
        model =
            { heroesList = list
            , searchBox = Nothing
            }
    in
        model ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateSearchBox string ->
            if string == "" then
                { model | searchBox = Nothing } ! []
            else
                { model | searchBox = Just string } ! []

        ViewDetails hero ->
            { model | searchBox = Nothing } ! [ newUrl <| "#heroes/" ++ toString hero.id ]
