module HeroSearch.View exposing (..)

import Html exposing (Html, div, h4, text, input)
import Html.Attributes exposing (id, class)
import Html.Events exposing (onInput, onClick)
import String exposing (toLower)
import App.Types exposing (..)
import Hero.Types exposing (..)


root : AppModel -> Html Msg
root model =
    let
        heroesList =
            case model.searchBox of
                Just searchBox ->
                    (model.heroesList |> searchHero searchBox |> List.map heroSearchItem)

                Nothing ->
                    [ div [] [] ]
    in
        div []
            [ h4 [] [ text "Hero Search" ]
            , input [ id "search-box", onInput UpdateSearchBox ] []
            , div []
                heroesList
            ]


heroSearchItem : Hero -> Html Msg
heroSearchItem hero =
    div [ class "search-result", onClick <| ViewDetails hero ] [ text hero.name ]


searchHero : String -> List Hero -> List Hero
searchHero string heroesList =
    heroesList
        |> List.filter
            (\hero -> hero.name |> String.toLower |> String.contains string)
