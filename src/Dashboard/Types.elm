module Dashboard.Types exposing (..)

import Hero.Types exposing (..)
import HeroSearch.Types exposing (..)


type alias Model =
    { heroesList : List Hero
    , heroSearchModel : HeroSearch.Types.Model
    }


type Msg
    = ViewDetails Hero
    | HeroSearch HeroSearch.Types.Msg
