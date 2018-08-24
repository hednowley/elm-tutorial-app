module View exposing (notFoundView, page, playerEditPage, view)

import Browser
import Html exposing (Html, div, text)
import Models exposing (Model, PlayerId)
import Msgs exposing (Msg)
import Pages.Edit
import Pages.List
import RemoteData


view : Model -> Browser.Document Msg
view model =
    { title = "App"
    , body = [ page model ]
    }


page : Model -> Html Msg
page model =
    case model.route of
        Models.PlayersRoute ->
            Pages.List.view model.players

        Models.PlayerRoute id ->
            playerEditPage model id

        Models.NotFoundRoute ->
            notFoundView


playerEditPage : Model -> PlayerId -> Html Msg
playerEditPage model playerId =
    case model.players of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading ..."

        RemoteData.Success players ->
            let
                maybePlayer =
                    players
                        |> List.filter (\player -> player.id == playerId)
                        |> List.head
            in
            case maybePlayer of
                Just player ->
                    Pages.Edit.view player

                Nothing ->
                    notFoundView

        RemoteData.Failure err ->
            text "Error"


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
