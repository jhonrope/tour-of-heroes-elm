module HeroDetail.Types exposing (..)

import Http exposing (Error)
import Hero.Types exposing (..)


type alias Model =
    { heroName : Maybe String
    , selectedHero : Maybe Hero
    }


type Msg
    = UpdateHeroName String
    | GoBack
    | UpdateHero Hero
    | UpdateHeroSucceed Hero
    | UpdateHeroFail Http.Error
