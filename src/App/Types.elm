module App.Types exposing (..)

import Http exposing (..)
import HeroDetail.Types exposing (..)
import Hero.Types exposing (..)


type alias AppModel =
    { title : String
    , heroesList : List Hero
    , route : Route
    , searchBox : Maybe String
    , heroDetailModel : HeroDetail.Types.Model
    , newHeroName : Maybe String
    }


type Msg
    = HeroDetail HeroDetail.Types.Msg
    | SelectHero Hero
    | ViewDetails Hero
    | FetchSucceed (List Hero)
    | FetchFail Http.Error
    | FetchHeroSucceed Hero
    | FetchHeroFail Http.Error
    | DeleteHero Hero
    | DeleteHeroSucceed Hero
    | DeleteHeroFail Http.Error
    | UpdateNewHeroName String
    | SaveHero
    | SaveHeroSucceed Hero
    | SaveHeroFail Http.Error
    | UpdateSearchBox String


type Route
    = Dashboard
    | Heroes
    | HeroDetails Int
    | NotFoundRoute
