module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.App exposing (program)
import Markdown
import Element
import Collage exposing (..)
import Color exposing (..)
import Time exposing (Time, second)
import Mouse


type Msg
    = Enlarge
    | Reset
    | Tick Time
    | Shrink


type alias Model =
    { radius : Float, isRed : Bool }


init =
    ( { radius = 25, isRed = True }, Cmd.none )


main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


view { radius, isRed } =
    div []
        [ h1 [] [ Html.text "Überschrift" ]
        , ol []
            [ li [] [ Html.text "Erstens" ]
            , li [] [ Html.text "Zweitens" ]
            , li [] [ Html.text "Drittens" ]
            ]
        , Markdown.toHtml [] "[link](https://github.com)"
        , Element.toHtml
            <| collage 100
                100
                [ filled
                    (if isRed then
                        red
                     else
                        blue
                    )
                    (circle radius)
                ]
        , button [ onClick Enlarge ] [ Html.text "Vergrößern" ]
        , button [ onClick Reset ] [ Html.text "Zurücksetzen" ]
        ]


update msg ({ radius, isRed } as model) =
    case msg of
        Enlarge ->
            ( { model | radius = radius + 2 }, Cmd.none )

        Shrink ->
            ( { model | radius = radius - 1 }, Cmd.none )

        Reset ->
            init

        Tick _ ->
            ( { model | isRed = not isRed }, Cmd.none )


subscriptions { radius } =
    if radius > 20 then
        Sub.batch
            [ Time.every second Tick
            , Mouse.clicks (\_ -> Shrink)
            ]
    else if radius > 0 then
        Mouse.clicks (\_ -> Shrink)
    else
        Sub.none

