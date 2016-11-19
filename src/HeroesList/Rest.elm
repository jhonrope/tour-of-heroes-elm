module HeroesList.Rest exposing (..)

import Http exposing (get)
import HeroesList.Types exposing (..)
import Hero.Types exposing (..)
import Task exposing (..)
import App.Rest exposing (..)


saveHero : Hero -> String -> Cmd Msg
saveHero hero url =
    Task.perform SaveHeroFail SaveHeroSucceed (post url hero)


deleteHero : String -> Cmd Msg
deleteHero url =
    Task.perform DeleteHeroFail DeleteHeroSucceed (delete url)


fetchHeroes : String -> Cmd Msg
fetchHeroes url =
    Task.perform FetchFail FetchSucceed (Http.get decodeListHero url)
