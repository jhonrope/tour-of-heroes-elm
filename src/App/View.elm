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


page : AppModel -> Html Msg
page model =
    case model.route of
        Heroes ->
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

        Dashboard ->
            div []
                [ h3 [] [ text "Top Heroes" ]
                , div [] (dashboardView model.heroesList)
                , heroSearch model
                ]

        HeroDetails id ->
            case model.heroDetailModel.selectedHero of
                Just h ->
                    HeroDetail.View.root (Just h) |> Html.App.map HeroDetail

                Nothing ->
                    div [] [ text "Loading..." ]

        NotFoundRoute ->
            div [] []


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


heroSearch : AppModel -> Html Msg
heroSearch model =
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


showHero : Hero -> Hero -> Html Msg
showHero hero2 hero =
    li [ onClick (SelectHero hero), addSelectedClass <| hero == hero2 ]
        [ span [ class "badge" ] [ text (toString hero.id) ]
        , span [] [ text (" " ++ hero.name) ]
        , button [ class "delete", otherClick <| DeleteHero hero ] [ text "x" ]
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


noBubble : Options
noBubble =
    { stopPropagation = True
    , preventDefault = True
    }


otherClick : Msg -> Attribute Msg
otherClick message =
    onWithOptions "click" noBubble (Json.succeed message)
