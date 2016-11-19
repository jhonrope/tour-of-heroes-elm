module App.Rest exposing (..)

import App.Types exposing (..)
import Task exposing (..)
import Json.Decode as Json
import Json.Encode
import Http exposing (..)
import Hero.Types exposing (..)


heroes : List Hero
heroes =
    [ Hero 1 "Mr. Nice"
    , Hero 2 "Narco"
    , Hero 3 "Bombasto"
    , Hero 4 "Celeritas"
    , Hero 5 "Magneta"
    , Hero 6 "RubberMan"
    , Hero 7 "Dynama"
    , Hero 8 "Dr IQ"
    , Hero 9 "Magma"
    , Hero 10 "Tornado"
    ]


getHeroes : List Hero
getHeroes =
    heroes


fetchHeroes : String -> Cmd Msg
fetchHeroes url =
    Task.perform FetchFail FetchSucceed (Http.get decodeListHero url)


fetchHero : String -> Cmd Msg
fetchHero url =
    Task.perform FetchFail FetchHeroSucceed (Http.get decodeHero url)





decodeListHero : Json.Decoder (List Hero)
decodeListHero =
    Json.list decodeHero


decodeHero : Json.Decoder Hero
decodeHero =
    Json.object2
        Hero
        (Json.at [ "id" ] Json.int)
        (Json.at [ "name" ] Json.string)


encodeHero : Hero -> Json.Encode.Value
encodeHero hero =
    Json.Encode.object
        [ ( "id", Json.Encode.int hero.id )
        , ( "name", Json.Encode.string hero.name )
        ]


encodedHeroBody : Hero -> Body
encodedHeroBody hero =
    encodeHero hero
        |> Json.Encode.encode 0
        |> Http.string


put : String -> Hero -> Task.Task Http.Error Hero
put url hero =
    let
        body =
            encodedHeroBody hero

        config =
            { verb = "PUT"
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = url
            , body = body
            }
    in
        Http.send Http.defaultSettings config
            |> Http.fromJson decodeHero


delete : String -> Task.Task Http.Error Hero
delete url =
    let
        config =
            { verb = "DELETE"
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = url
            , body = empty
            }
    in
        Http.send Http.defaultSettings config
            |> Http.fromJson (Json.succeed (Hero 1 ""))


post : String -> Hero -> Task.Task Http.Error Hero
post url hero =
    let
        body =
            encodedHeroBody hero

        config =
            { verb = "POST"
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = url
            , body = body
            }
    in
        Http.send Http.defaultSettings config
            |> Http.fromJson decodeHero
