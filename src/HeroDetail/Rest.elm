module HeroDetail.Rest exposing (updateHero)

import Task exposing (perform)
import App.Rest exposing (put)
import Hero.Types exposing (..)
import HeroDetail.Types exposing (..)


updateHero : Hero -> String -> Cmd Msg
updateHero hero url =
    Task.perform UpdateHeroFail UpdateHeroSucceed (put url hero)
