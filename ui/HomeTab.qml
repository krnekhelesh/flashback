/*
 * Flashback - Entertainment app for Ubuntu
 * Copyright (C) 2013, 2014 Nekhelesh Ramananthan <nik90@ubuntu.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import QtQuick 2.0
import Ubuntu.Components 1.1
import "../backend/backend.js" as Backend
import "../components"
import "../models"

Page {
    id: homeTab

    flickable: null

    Component.onCompleted: console.log("[LOG]: Home Tab Loaded")

    actions: [
        Action {
            id: appSettingsAction
            text: i18n.tr("Settings")
            visible: !createAccountMessage.visible
            keywords: i18n.tr("Settings;Setting;Configuration;Account;Authenticate")
            description: i18n.tr("Application Settings")
            iconSource: Qt.resolvedUrl("../graphics/settings.svg")
            onTriggered: pagestack.push(Qt.resolvedUrl("SettingPage.qml"))
        },

        Action {
            id: setupAccountAction
            text: i18n.tr("Account")
            visible: createAccountMessage.visible
            keywords: i18n.tr("Setup;Create;Account;Trakt")
            description: i18n.tr("Setup a Trakt Account")
            iconSource: Qt.resolvedUrl("../graphics/add.png")
            onTriggered: pageStack.push(Qt.resolvedUrl("Trakt.qml"))
        },

        Action {
            id: searchAllAction
            text: i18n.tr("Search")
            visible: !account.visible
            keywords: i18n.tr("Search;Tv;Show;Shows;Find;Movie;Movies;Actor;Celeb")
            description: i18n.tr("Search All")
            iconSource: Qt.resolvedUrl("../graphics/find.svg")
            onTriggered: pageStack.push(Qt.resolvedUrl("SearchAll.qml"))
        }
    ]

    // Tab Background
    Background {}

    Movies {
        id: nowPlayingMoviesModel
        source: Backend.nowPlayingMoviesUrl()
    }

    TraktUserWatchlist {
        id: userWatchlistModel
        username: traktLogin.contents.username
        password: traktLogin.contents.password
        lastUpdated: Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")
        lastAction: watchlistActivityDocument.contents.movie
        onPasswordChanged: {
            console.log("[LOG]: Retrieving user movie watchlist")
            fetchData(username, password)
        }
        onLastActionChanged: {
            // Update user watchlist only if user is logged in and this action has not been exectued a second ago
            if(username !== "" && lastUpdated !== Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")) {
                lastUpdated = Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")
                // If movie is added to watchlist, update list data from Trakt
                if(lastAction.split("->")[0] === "Added") {
                    console.log("[LOG]: Retrieving user movie watchlist")
                    fetchData(username, password)
                }
                // If movie is removed from watchlist, remove it from the model locally
                else if(lastAction.split("->")[0] === "Removed"){
                    console.log("[LOG]: Removing %1 from the user watchlist (locally)".arg(lastAction.split("->")[1]))
                    for(var i=0; i<model.count; i++) {
                        if(model.get(i).name === lastAction.split("->")[1])
                            model.remove(i)
                    }
                }
            }
        }
    }

    AiringShows {
        id: airingShowsModel
        username: traktLogin.contents.username
        password: traktLogin.contents.password
        lastUpdated: Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")
        lastAction: watchlistActivityDocument.contents.show
        onPasswordChanged: {
            console.log("[LOG]: Retrieving shows airing today")
            fetchData(username, password, Qt.formatDate(new Date(), "yyyyMMdd"), 1)
        }
        onLastActionChanged: {
            if(username !== "" && lastUpdated !== Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")) {
                lastUpdated = Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")
                if(lastAction.split("->")[0] === "Added") {
                    console.log("[LOG]: Retrieving shows airing today")
                    fetchData(username, password, Qt.formatDate(new Date(), "yyyyMMdd"), 1)
                }
                else if(lastAction.split("->")[0] === "Removed") {
                    console.log("[LOG]: Removing %1 from the shows airing today list (locally)".arg(lastAction.split("->")[1]))
                    for(var i=0; i<model.count; i++) {
                        if(model.get(i).name === lastAction.split("->")[1])
                            model.remove(i)
                    }
                }
            }
        }
    }

    AiringShows {
        id: airedShowsModel

        property string lastShowAction: watchlistActivityDocument.contents.show

        username: traktLogin.contents.username
        password: traktLogin.contents.password
        lastUpdated: Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")
        lastAction: episodeSeenActivityDocument.contents.episode
        hideWatched: true
        onPasswordChanged: {
            console.log("[LOG]: Retrieving recently aired shows")
            var dt = new Date()
            dt.setDate(dt.getDate()-7)
            fetchData(username, password, Qt.formatDate(dt, "yyyyMMdd"), 7)
        }
        onLastActionChanged: {
            if(username !== "" && lastUpdated !== Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")) {
                lastUpdated = Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")
                if(lastAction.split("->")[0] === "Seen") {
                    console.log("[LOG]: Removing %1 from the recently aired shows list (locally)".arg(lastAction.split("->")[1]))
                    for(var i=0; i<model.count; i++) {
                        if(model.get(i).episode_name === lastAction.split("->")[1])
                            model.remove(i)
                    }
                }
            }
        }
        onLastShowActionChanged: {
            if(username !== "" && lastUpdated !== Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")) {
                lastUpdated = Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")
                if(lastShowAction.split("->")[0] === "Added") {
                    console.log("[LOG]: Retrieving recently aired shows")
                    var dt = new Date()
                    dt.setDate(dt.getDate()-7)
                    fetchData(username, password, Qt.formatDate(dt, "yyyyMMdd"), 7)
                }
                else if(lastShowAction.split("->")[0] === "Removed") {
                    console.log("[LOG]: Removing %1 from the recently aired shows list (locally)".arg(lastShowAction.split("->")[1]))
                    for(var i=0; i<model.count; i++) {
                        if(model.get(i).name === lastShowAction.split("->")[1])
                            model.remove(i)
                    }
                }
            }
        }
    }

    LoadingIndicator {
        isShown: !createAccountMessage.visible ? (nowPlayingMoviesModel.loading
                                                  || airedShowsModel.loading
                                                  || airingShowsModel.loading
                                                  || userWatchlistModel.loading ? true : false)
                                               : false
    }

    Flickable {
        id: flickable
        clip: true
        anchors.fill: parent
        contentHeight: mainColumn.height + units.gu(5)
        visible: !createAccountMessage.visible

        Column {
            id: mainColumn

            spacing: units.gu(2)

            anchors {
                left: parent.left;
                right: parent.right;
                top: parent.top;
            }

            NowWatching {
                id: watchingMovie

                backgroundFanArt: movieActivityDocument.contents.name !== "default" ? movieActivityDocument.contents.fanart : ""
                posterArt: movieActivityDocument.contents.name !== "default" ? movieActivityDocument.contents.poster : ""
                title: movieActivityDocument.contents.name !== "default" ? movieActivityDocument.contents.name : ""
                subtitle: movieActivityDocument.contents.name !== "default" ? "Length: " + movieActivityDocument.contents.runtime + " mins, Year: " + movieActivityDocument.contents.year : ""

                visible: movieActivityDocument.contents.name !== "default"
                showTrailer: true

                onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": movieActivityDocument.contents.id})
                onTrailerClicked: Qt.openUrlExternally(movieActivityDocument.contents.trailer)

                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            NowWatching {
                id: watchingShow

                backgroundFanArt: showActivityDocument.contents.name !== "default" ? showActivityDocument.contents.fanart : ""
                posterArt: showActivityDocument.contents.name !== "default" ? showActivityDocument.contents.poster : ""
                title: showActivityDocument.contents.name !== "default" ? showActivityDocument.contents.name : ""
                subtitle: showActivityDocument.contents.name !== "default" ? showActivityDocument.contents.episode_title : ""
                extra: showActivityDocument.contents.name !== "default" ? "S" + showActivityDocument.contents.season + "E" + showActivityDocument.contents.number : ""

                visible: showActivityDocument.contents.name !== "default"

                onThumbClicked: pageStack.push(Qt.resolvedUrl("EpisodePage.qml"), {"tv_id": showActivityDocument.contents.id, "season_number": showActivityDocument.contents.season, "episode_number": showActivityDocument.contents.number, "episode_name": showActivityDocument.contents.episode_title})

                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            DetailCarousel {
                id: airingShows
                dataModel: airingShowsModel.model
                showDate: false
                header: i18n.tr("Episodes Airing Today")
                onThumbClicked: pageStack.push(Qt.resolvedUrl("EpisodePage.qml"), {"tv_id": model.id, "season_number": model.season, "episode_number": model.episode, "watched": model.watched})
            }

            DetailCarousel {
                id: airedShows
                dataModel: airedShowsModel.model
                header: i18n.tr("Recently Aired Unwatched Episodes")
                visible: traktLogin.contents.status !== "disabled" && airedShowsModel.count > 0
                onThumbClicked: pageStack.push(Qt.resolvedUrl("EpisodePage.qml"), {"tv_id": model.id, "season_number": model.season, "episode_number": model.episode, "watched": model.watched})
            }

            Carousel {
                id: userWatchlist
                dataModel: userWatchlistModel.model
                header: i18n.tr("Your Movie Watchlist")
                visible: traktLogin.contents.status !== "disabled" && userWatchlistModel.count > 0
                onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
            }

            Carousel {
                id: nowPlaying
                dataModel: nowPlayingMoviesModel.model
                header: i18n.tr("Now Playing In Theatres")
                onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
            }
        }
    }

    EmptyState {
        id: createAccountMessage
        logo: Qt.resolvedUrl("../graphics/account.png")
        header: i18n.tr("No Trakt Account")
        message: i18n.tr("Please set up an account using the add \"Accounts\" button.")
        visible: traktLogin.contents.status === "disabled"
    }

    Image {
        id: arrow
        source: Qt.resolvedUrl("../graphics/arrow.png")
        width: units.gu(8)
        height: width
        smooth: true
        visible: createAccountMessage.visible
        transform: Rotation {
            axis { x: 0; y: 0; z: 1 }
            angle: -90
        }
        anchors {
            right: parent.right
            top: parent.top
            topMargin: units.gu(10)
            rightMargin: units.gu(-1.5)
        }

        SequentialAnimation on anchors.topMargin {
            running: createAccountMessage.visible
            loops: 5
            NumberAnimation { from: units.gu(10); to: units.gu(13); duration: 1000 }
            PauseAnimation { duration: 250 }
            NumberAnimation { from: units.gu(13); to: units.gu(10); duration: 1000 }
        }
    }

    tools: ToolbarItems {
        id: toolbarHome

        ToolbarButton {
            id: settings
            action: appSettingsAction
        }

        ToolbarButton {
            id: account
            action: setupAccountAction
        }

        ToolbarButton {
            id: search
            action: searchAllAction
        }
    }
}
