module Routing exposing (..)

import String
import Navigation
import UrlParser exposing (..)
import Debug exposing (log)


type Route
    = Dashboard
    | Heroes
    | HeroDetail Int
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ format Dashboard (s "")
        , format HeroDetail (s "heroes" </> int)
        , format Heroes (s "heroes")
        , format Dashboard (s "dashboard")
        ]


hashParser : Navigation.Location -> Result String Route
hashParser location =
    location.hash
        |> String.dropLeft 1
        |> parse identity matchers


parser : Navigation.Parser (Result String Route)
parser =
    Navigation.makeParser hashParser


routeFromResult : Result String Route -> Route
routeFromResult result =
    case result of
        Ok route ->
            route

        Err string ->
            NotFoundRoute
