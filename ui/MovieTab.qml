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
import Ubuntu.Layouts 1.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {
    id: movieTab

    flickable: null

    Component.onCompleted: console.log("[LOG]: Movie Tab Loaded")

    // Tab Background
    Background {}

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

    /*
      Phone and Tablet UI Definitions
     */
    Layouts {
        id: movieLayout
        anchors.fill: parent

        layouts: [
            MovieTabTablet {}
        ]

        LoadingIndicator {
            isShown: nowPlayingMoviesModel.loading || upcomingMoviesModel.loading || trendingMoviesModel.loading && movieTab.state !== "search"
        }

        Flickable {
            id: flickable
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

                ListItem.Header {
                    id: filterHeader
                    Layouts.item: "filter-header"
                    text: i18n.tr("Filter By")
                }

                ListItem.Standard {
                    text: i18n.tr("Genre")
                    progression: true
                    onClicked: pageStack.push(Qt.resolvedUrl("MovieByGenre.qml"))
                }

                ListItem.Standard {
                    text: i18n.tr("Top Rated")
                    progression: true
                    onClicked: pageStack.push(Qt.resolvedUrl("MovieByRating.qml"))
                }

                ListItem.Standard {
                    text: i18n.tr("Recommended")
                    progression: true
                    visible: traktLogin.contents.status !== "disabled"
                    onClicked: pageStack.push(Qt.resolvedUrl("MovieByRecommendation.qml"))
                }
            }
        }

        Loader {
            id: searchPageLoader
            anchors.fill: parent
        }

        Component {
            id: searchPageComponent
            SearchPage {
                id: searchPage

                type: "movie"
                search_model: search_results
                onResultClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})

                Movies {
                    id: search_results
                }
            }
        }
    }

    Action {
        id: searchMovieAction
        text: i18n.tr("Movie")
        keywords: i18n.tr("Search;Movie;Movies;Find")
        description: i18n.tr("Search for Movies")
        iconName: "search"
        onTriggered: {
            movieTab.state = "search"
            searchField.forceActiveFocus()
            flickable.visible = false
            searchPageLoader.sourceComponent = searchPageComponent
        }
    }

    state: "default"
    states: [
        PageHeadState {
            name: "default"
            head: movieTab.head
            actions: [
                searchMovieAction,
                appSettingsAction
            ]
        },

        PageHeadState {
            name: "search"
            head: movieTab.head
            backAction: Action {
                iconName: "back"
                text: i18n.tr("Back")
                onTriggered: {
                    movieTab.state = "default"
                    flickable.visible = true
                    searchField.text = ""
                    searchPageLoader.sourceComponent = undefined
                }
            }

            contents: SearchBox {
                id: searchField
                defaultText: i18n.tr("Search movie...")
                anchors {
                    left: parent ? parent.left : undefined
                    right: parent ? parent.right : undefined
                    rightMargin: units.gu(2)
                }

                onSearchTriggered: {
                    if (searchPageLoader.status === Loader.Ready) {
                        searchPageLoader.item.search_model.model.clear()
                    }
                    if (searchField.text !== "") {
                        searchPageLoader.item.search_model.source = Backend.searchUrl(searchPageLoader.item.type, searchField.search_term)
                    }
                }
            }
        }
    ]
}
