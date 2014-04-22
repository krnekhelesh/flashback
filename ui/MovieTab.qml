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
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {

    flickable: null

    Component.onCompleted: console.log("[LOG]: Movie Tab Loaded")

    TrendingMovies {
        id: trendingMoviesModel
        Component.onCompleted: {
            trendingMoviesModel.createMessage(traktLogin.contents.username, traktLogin.contents.password)
            trendingMoviesModel.sendMessage()
        }
    }

    Movies {
        id: nowPlayingMoviesModel
        source: Backend.nowPlayingMoviesUrl()
    }

    Movies {
        id: upcomingMoviesModel
        source: Backend.upcomingMoviesUrl()
    }

    actions: [
        Action {
            id: searchMovieAction
            text: i18n.tr("Movie")
            keywords: i18n.tr("Search;Movie;Movies;Find")
            description: i18n.tr("Search for Movies")
            iconSource: Qt.resolvedUrl("../graphics/find.svg")
            onTriggered: pageStack.push(Qt.resolvedUrl("SearchMovie.qml"))
        }
    ]

    LoadingIndicator {
        animate: true
        isShown: !nowPlayingMoviesModel.count > 0 || !upcomingMoviesModel.count > 0 || !trendingMoviesModel.count > 0
    }

    Flickable {
        clip: true
        anchors.fill: parent
        contentHeight: mainHomeColumn.height + units.gu(5)
        interactive: contentHeight > parent.height

        Column {
            id: mainHomeColumn

            anchors {
                left: parent.left;
                right: parent.right;
                top: parent.top;
                margins: units.gu(1)
            }

            spacing: units.gu(1)

            Carousel {
                id: trendingMovies
                dataModel: trendingMoviesModel.model
                header: i18n.tr("Trending Movies")
                onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
            }

            Carousel {
                id: nowPlaying
                dataModel: nowPlayingMoviesModel.model
                header: i18n.tr("Now Playing In Theatres")
                onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
            }

            Carousel {
                id: upcomingMovies
                dataModel: upcomingMoviesModel.model
                header: i18n.tr("Upcoming Movies in Theatres")
                onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
            }

            Header { text: i18n.tr("Filter") }

            Standard {
                text: i18n.tr("By Genre")
                progression: true
                onClicked: pageStack.push(Qt.resolvedUrl("MovieByGenre.qml"))
            }

            Standard {
                text: i18n.tr("Top Rated")
                progression: true
                onClicked: pageStack.push(Qt.resolvedUrl("MovieByRating.qml"))
            }

            Standard {
                text: i18n.tr("Recommended")
                progression: true
                visible: traktLogin.contents.status !== "disabled"
                onClicked: pageStack.push(Qt.resolvedUrl("MovieByRecommendation.qml"))
            }
        }
    }

    tools: ToolbarItems {
        id: toolbarMovies

        ToolbarButton {
            id: settings
            action: appSettingsAction
        }

        ToolbarButton {
            id: searchMovies
            action: searchMovieAction
        }
    }
}
