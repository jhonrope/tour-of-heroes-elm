module Dashboard.State exposing (..)

import Dashboard.Types exposing (..)
import Navigation exposing (..)
import HeroDetail.State exposing (..)
import HeroSearch.State exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        model =
            { heroesList = []
            , heroSearchModel = fst <| HeroSearch.State.init []
            }
    in
        model ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ViewDetails hero ->
            { model | heroSearchModel = fst <| HeroSearch.State.init model.heroesList } ! [ newUrl <| "#heroes/" ++ toString hero.id ]

        HeroSearch heroSearch ->
            let
                ( newModel, newCmd ) =
                    HeroSearch.State.update heroSearch model.heroSearchModel

                otroNewModel =
                    { newModel | heroesList = model.heroesList }
            in
                { model | heroSearchModel = otroNewModel } ! [ Cmd.map HeroSearch newCmd ]

        FetchSucceed list ->
            { model | heroesList = list } ! []

        FetchFail message ->
            { model | heroesList = [] } ! []
