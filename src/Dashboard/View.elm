module Dashboard.View exposing (..)

import Html exposing (Html, div, h3, h4, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import App.Types exposing (..)
import HeroSearch.View as HeroSearch exposing (..)
import Hero.Types exposing (..)


root : AppModel -> Html Msg
root model =
    div []
        [ h3 [] [ text "Top Heroes" ]
        , div [] (dashboardView model.heroesList)
        , HeroSearch.root model
        ]


heroDashboard : Hero -> Html Msg
heroDashboard hero =
    div [ class "col-1-4", onClick (ViewDetails hero) ]
        [ div [ class "module hero" ]
            [ h4 [] [ text hero.name ] ]
        ]


dashboardView : List Hero -> List (Html Msg)
dashboardView list =
    list
        |> List.drop 1
        |> List.take 4
        |> List.map heroDashboard
