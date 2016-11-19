module HeroesList.Types exposing (..)

import Http exposing (Error)
import Hero.Types exposing (..)


type alias Model =
    { newHeroName : Maybe String
    , selectedHero : Maybe Hero
    , heroesList : List Hero
    }


type Msg
    = UpdateNewHeroName String
    | SelectHero Hero
    | ViewDetails Hero
    | SaveHero
    | SaveHeroSucceed Hero
    | SaveHeroFail Http.Error
    | DeleteHero Hero
    | DeleteHeroSucceed Hero
    | DeleteHeroFail Http.Error
    | FetchSucceed (List Hero)
    | FetchFail Http.Error
