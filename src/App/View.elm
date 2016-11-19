module App.View exposing (..)

import Html exposing (Html, div, h1, h2, h3, h4, text, nav, a, label, input, button, ul, li, span, Attribute)
import Html.Attributes exposing (href, class, value, type', id)
import Html.App exposing (..)
import Html.Events exposing (onInput, onClick, Options, onWithOptions)
import App.Types exposing (..)
import Hero.Types exposing (..)
import HeroDetail.View exposing (root)
import String exposing (toUpper)
import Json.Decode as Json
import Heroes.View exposing (..)
import Dashboard.View exposing (..)


root : AppModel -> Html Msg
root model =
    div []
        [ h1 [] [ text model.title ]
        , nav []
            [ a [ href "#dashboard", addActiveClass Dashboard model.route ] [ text "Dashboard" ]
            , a [ href "#heroes", addActiveClass Heroes model.route ] [ text "Heroes" ]
            ]
        , page model
        ]


page : AppModel -> Html Msg
page model =
    case model.route of
        Heroes ->
            Heroes.View.root model

        Dashboard ->
            Dashboard.View.root model

        HeroDetails id ->
            case model.heroDetailModel.selectedHero of
                Just h ->
                    HeroDetail.View.root (Just h) |> Html.App.map HeroDetail

                Nothing ->
                    div [] [ text "Loading..." ]

        NotFoundRoute ->
            div [] []


addActiveClass : Route -> Route -> Html.Attribute Msg
addActiveClass route c =
    if route == c then
        class "active"
    else
        class ""


addSelectedClass : Bool -> Html.Attribute Msg
addSelectedClass bool =
    if bool then
        class "selected"
    else
        class ""
