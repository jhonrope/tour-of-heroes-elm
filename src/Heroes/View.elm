module Heroes.View exposing (root)

import Html exposing (Html, div, h2, label, text, input, button, ul, li, span, Attribute)
import Html.Attributes exposing (type', value, class)
import Html.Events exposing (onInput, onClick, Options, onWithOptions)
import String exposing (toUpper)
import App.Types exposing (..)
import Hero.Types exposing (..)
import Json.Decode as Json


root : AppModel -> Html Msg
root model =
    div []
        [ h2 [] [ text "My Heroes" ]
        , div []
            [ label [] [ text "Hero name:" ]
            , input [ type' "text", onInput UpdateNewHeroName, value <| Maybe.withDefault "" model.newHeroName ] []
            , button [ onClick SaveHero ] [ text "Add" ]
            ]
        , ul [ class "heroes" ]
            -- Fix
            (List.map (showHero (Maybe.withDefault (Hero 0 "") model.heroDetailModel.selectedHero)) model.heroesList)
        , miniDetail model.heroDetailModel.selectedHero
        ]


miniDetail : Maybe Hero -> Html Msg
miniDetail maybeHero =
    case maybeHero of
        Just hero ->
            div []
                [ h2 [] [ text <| (String.toUpper hero.name) ++ " is my hero" ]
                , button [ onClick (ViewDetails hero) ] [ text "View Details" ]
                ]

        Nothing ->
            div [] []


showHero : Hero -> Hero -> Html Msg
showHero hero2 hero =
    div [ onClick <| SelectHero hero ]
        [ span [ class "badge" ] [ text (toString hero.id) ]
        , span [] [ text (" " ++ hero.name) ]
        , button [ class "delete", otherClick <| DeleteHero hero ] [ text "x" ]
        ]


noBubble : Options
noBubble =
    { stopPropagation = True
    , preventDefault = True
    }


otherClick : Msg -> Attribute Msg
otherClick message =
    onWithOptions "click" noBubble (Json.succeed message)
