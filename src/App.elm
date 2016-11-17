module App exposing (..)

import Html.App
import Debug exposing (log)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Rest exposing (..)
import HeroDetail exposing (..)
import Routing exposing (..)
import Navigation exposing (..)
import String exposing (..)
import Html exposing (..)
import Json.Decode as Json


type alias AppModel =
    { title : String
    , selectedHero : Maybe Hero
    , heroesList : List Hero
    , route : Route
    , newHeroName : Maybe String
    , searchBox : Maybe String
    }


initApp : Route -> AppModel
initApp route =
    { title = "Tour of Heroes"
    , selectedHero = Nothing
    , heroesList = []
    , route = route
    , newHeroName = Nothing
    , searchBox = Nothing
    }


init : Result String Route -> ( AppModel, Cmd Msg )
init result =
    let
        currentRoute =
            Routing.routeFromResult result

        url =
            "http://localhost:3000/heroes"
    in
        ( initApp currentRoute, newUrl "#dashboard" )


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of
        UpdateHeroDetailName newName ->
            case model.selectedHero of
                Just previousHero ->
                    { model | selectedHero = Just { previousHero | name = newName } } ! []

                Nothing ->
                    model ! []

        SelectHero hero ->
            { model | selectedHero = Just hero } ! []

        ViewDetails hero ->
            { model | selectedHero = Nothing, searchBox = Nothing } ! [ newUrl <| "#heroes/" ++ toString hero.id ]

        GoBack ->
            { model | selectedHero = Nothing } ! [ back 1 ]

        FetchSucceed list ->
            { model | heroesList = list } ! []

        FetchFail message ->
            { model | heroesList = [] } ! []

        FetchHeroSucceed hero ->
            { model | selectedHero = Just hero } ! []

        FetchHeroFail message ->
            model ! []

        UpdateHero hero ->
            { model | selectedHero = Nothing } ! [ updateHero hero <| "http://localhost:3000/heroes/" ++ toString hero.id ]

        UpdateHeroSucceed hero ->
            model ! [ back 1 ]

        UpdateHeroFail message ->
            model ! []

        DeleteHero hero ->
            model ! [ deleteHero <| "http://localhost:3000/heroes/" ++ toString hero.id ]

        DeleteHeroSucceed hero ->
            { model | selectedHero = Nothing } ! [ newUrl "#heroes" ]

        DeleteHeroFail message ->
            let
                _ =
                    log "failed" message
            in
                { model | selectedHero = Nothing } ! []

        UpdateNewHeroName newName ->
            { model | newHeroName = Just newName } ! []

        SaveHero ->
            case model.newHeroName of
                Just newName ->
                    { model | newHeroName = Nothing } ! [ saveHero (Hero 0 newName) "http://localhost:3000/heroes" ]

                Nothing ->
                    model ! []

        SaveHeroSucceed hero ->
            let
                newList =
                    model.heroesList ++ [ hero ]
            in
                { model | newHeroName = Nothing, heroesList = newList } ! []

        SaveHeroFail message ->
            model ! []

        UpdateSearchBox string ->
            if string == "" then
                { model | searchBox = Nothing } ! []
            else
                { model | searchBox = Just string } ! []


showHero : Hero -> Hero -> Html Msg
showHero hero2 hero =
    li [ onClick (SelectHero hero), addSelectedClass <| hero == hero2 ]
        [ span [ class "badge" ] [ text (toString hero.id) ]
        , span [] [ text (" " ++ hero.name) ]
        , button [ class "delete", otherClick <| DeleteHero hero ] [ text "x" ]
        ]


view : AppModel -> Html Msg
view model =
    div []
        [ h1 [] [ text model.title ]
        , nav []
            [ a [ href "#dashboard", addActiveClass Dashboard model.route ] [ text "Dashboard" ]
            , a [ href "#heroes", addActiveClass Heroes model.route ] [ text "Heroes" ]
            ]
        , page model
        ]


addActiveClass : Routing.Route -> Routing.Route -> Html.Attribute Msg
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


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none


urlUpdate : Result String Route -> AppModel -> ( AppModel, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        case currentRoute of
            HeroDetail id ->
                { model | route = currentRoute } ! [ fetchHero ("http://localhost:3000/heroes/" ++ (toString id)) ]

            Dashboard ->
                { model | route = currentRoute } ! [ fetchHeroes "http://localhost:3000/heroes" ]

            Heroes ->
                { model | route = currentRoute } ! [ fetchHeroes "http://localhost:3000/heroes" ]

            other ->
                { model | route = other } ! []


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
                    (List.map (showHero (Maybe.withDefault (Hero 0 "") model.selectedHero)) model.heroesList)
                , miniDetail model.selectedHero
                ]

        Dashboard ->
            div []
                [ h3 [] [ text "Top Heroes" ]
                , div [] (dashboardView model.heroesList)
                , heroSearch model
                ]

        HeroDetail id ->
            case model.selectedHero of
                Just h ->
                    HeroDetail.heroDetail (Just h)

                Nothing ->
                    div [] [ text "Loading..." ]

        NotFoundRoute ->
            div [] []


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , urlUpdate = urlUpdate
        }


noBubble : Options
noBubble =
    { stopPropagation = True
    , preventDefault = True
    }


otherClick : Msg -> Attribute Msg
otherClick message =
    onWithOptions "click" noBubble (Json.succeed message)
