module Dashboard.Rest exposing (..)

import Http exposing (..)
import Task exposing (perform)
import App.Rest exposing (..)
import Dashboard.Types exposing (..)


fetchHeroes : String -> Cmd Msg
fetchHeroes url =
    Task.perform FetchFail FetchSucceed (Http.get decodeListHero url)
