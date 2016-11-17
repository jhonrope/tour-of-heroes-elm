module HeroDetail.Rest exposing (updateHero)

import Task exposing (perform)
import HeroDetail.Types exposing (..)
import App.Rest exposing (put)
import Hero.Types exposing (..)


updateHero : Hero -> String -> Cmd Msg
updateHero hero url =
    Task.perform UpdateHeroFail UpdateHeroSucceed (put url hero)
