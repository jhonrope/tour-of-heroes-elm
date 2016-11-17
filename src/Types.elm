module Types exposing (..)

import Http exposing (..)


type alias Hero =
    { id : Int
    , name : String
    }


type Msg
    = UpdateHeroDetailName String
    | SelectHero Hero
    | GoBack
    | ViewDetails Hero
    | FetchSucceed (List Hero)
    | FetchFail Http.Error
    | FetchHeroSucceed Hero
    | FetchHeroFail Http.Error
    | UpdateHero Hero
    | UpdateHeroSucceed Hero
    | UpdateHeroFail Http.Error
    | DeleteHero Hero
    | DeleteHeroSucceed Hero
    | DeleteHeroFail Http.Error
    | UpdateNewHeroName String
    | SaveHero
    | SaveHeroSucceed Hero
    | SaveHeroFail Http.Error
    | UpdateSearchBox String
