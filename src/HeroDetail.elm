module HeroDetail exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


heroDetail : Maybe Hero -> Html Msg
heroDetail maybeHero =
    case maybeHero of
        Just hero ->
            div []
                [ h2 [] [ text (hero.name ++ " details!") ]
                , div []
                    [ label [] [ text "id: " ]
                    , text (toString hero.id)
                    ]
                , div []
                    [ label [] [ text "name: " ]
                    , input [ type' "text", value hero.name, placeholder "Name", onInput UpdateHeroDetailName ] []
                    ]
                , button [ onClick GoBack ] [ text "Back" ]
                , button [ onClick <| UpdateHero hero ] [ text "Save" ]
                ]

        Nothing ->
            div [] []
