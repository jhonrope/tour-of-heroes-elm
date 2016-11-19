module Dashboard.View exposing (..)

import Html exposing (Html, div, h3, h4, text)
import Html.App exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import HeroSearch.View as HeroSearch exposing (..)
import Hero.Types exposing (..)
import Dashboard.Types exposing (..)


root : Model -> Html Msg
root model =
    div []
        [ h3 [] [ text "Top Heroes" ]
        , dashboardView model.heroesList
        , HeroSearch.root model.heroSearchModel |> Html.App.map HeroSearch
        ]


heroDashboard : Hero -> Html Msg
heroDashboard hero =
    div [ class "col-1-4", onClick (ViewDetails hero) ]
        [ div [ class "module hero" ]
            [ h4 [] [ text hero.name ] ]
        ]


dashboardView : List Hero -> Html Msg
dashboardView list =
    div []
        (list
            |> List.drop 1
            |> List.take 4
            |> List.map heroDashboard
        )
