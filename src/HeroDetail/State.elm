module HeroDetail.State exposing (..)

import Navigation exposing (back)
import HeroDetail.Rest exposing (updateHero)
import HeroDetail.Types exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        model =
            { heroName = Nothing
            , selectedHero = Nothing
            }
    in
        model ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateHeroName newName ->
            case model.selectedHero of
                Just previousHero ->
                    { model | selectedHero = Just { previousHero | name = newName } } ! []

                Nothing ->
                    model ! []

        GoBack ->
            { model | selectedHero = Nothing } ! [ back 1 ]

        UpdateHero hero ->
            { model | selectedHero = Nothing } ! [ updateHero hero <| "http://localhost:3000/heroes/" ++ toString hero.id ]

        UpdateHeroSucceed hero ->
            model ! [ back 1 ]

        UpdateHeroFail message ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
