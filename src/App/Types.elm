module App.Types exposing (..)

import Http exposing (..)
import HeroDetail.Types exposing (..)
import Hero.Types exposing (..)
import HeroesList.Types exposing (..)
import Dashboard.Types exposing (..)


type alias AppModel =
    { title : String
    , route : Route
    , heroesListModel : HeroesList.Types.Model
    , heroDetailModel : HeroDetail.Types.Model
    , dashboardModel : Dashboard.Types.Model
    , heroesList : List Hero
    }


type Msg
    = HeroDetail HeroDetail.Types.Msg
    | HeroesList HeroesList.Types.Msg
    | DashboardT Dashboard.Types.Msg
    | FetchSucceed (List Hero)
    | FetchFail Http.Error
    | FetchHeroSucceed Hero
    | FetchHeroFail Http.Error


type Route
    = Dashboard
    | Heroes
    | HeroDetails Int
    | NotFoundRoute
