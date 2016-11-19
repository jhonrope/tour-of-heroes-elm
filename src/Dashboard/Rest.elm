module Dashboard.Rest exposing (..)

import Http exposing (get)
import Task exposing (perform)
import App.Rest exposing (decodeListHero)
import Dashboard.Types exposing (..)


fetchHeroes : String -> Cmd Msg
fetchHeroes url =
    Task.perform FetchFail FetchSucceed (Http.get decodeListHero url)
