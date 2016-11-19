module HeroSearch.Types exposing (..)

import Hero.Types exposing (..)


type alias Model =
    { heroesList : List Hero
    , searchBox : Maybe String
    }


type Msg
    = UpdateSearchBox String
    | ViewDetails Hero
