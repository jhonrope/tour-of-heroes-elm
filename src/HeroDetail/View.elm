module HeroDetail.View exposing (root)

import Html exposing (Html, div, h2, text, label, input, button)
import Html.Attributes exposing (type', value, placeholder)
import Html.Events exposing (onClick, onInput)
import HeroDetail.Types exposing (..)
import Hero.Types exposing (..)


root : Maybe Hero -> Html Msg
root maybeHero =
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
                    , input
                        [ type' "text"
                        , value hero.name
                        , placeholder "Name"
                        , onInput UpdateHeroName
                        ]
                        []
                    ]
                , button [ onClick GoBack ] [ text "Back" ]
                , button [ onClick <| UpdateHero hero ] [ text "Save" ]
                ]

        Nothing ->
            div [] []
