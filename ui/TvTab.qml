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
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {
    id: tvTab

    flickable: null

    Component.onCompleted: console.log("[LOG]: TV Tab Loaded")

    // Tab Background
    Background {}

    Shows {
        id: trendingShowsModel
        Component.onCompleted: {
            trendingShowsModel.createMessage(traktLogin.contents.username, traktLogin.contents.password)
            trendingShowsModel.sendMessage()
        }
    }

    AiringShows {
        id: airingShowsModel
        username: traktLogin.contents.username
        password: traktLogin.contents.password
        lastUpdated: Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")
        lastAction: watchlistActivityDocument.contents.show
        onPasswordChanged: {
            console.log("[LOG]: Retrieving upcoming shows")
            fetchData(username, password, Qt.formatDate(new Date(), "yyyyMMdd"), 14)
        }
        onLastActionChanged: {
            // Update user watchlist only if user is logged in and this action has not been exectued a second ago
            if(username !== "" && lastUpdated !== Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")) {
                lastUpdated = Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")
                // If show is added to watchlist, update list data from Trakt
                if(lastAction.split("->")[0] === "Added") {
                    console.log("[LOG]: Retrieving upcoming shows")
                    fetchData(username, password, Qt.formatDate(new Date(), "yyyyMMdd"), 14)
                }
                // If show is removed from watchlist, remove it from the model locally
                else if(lastAction.split("->")[0] === "Removed"){
                    console.log("[LOG]: Removing %1 from the upcoming shows list (locally)".arg(lastAction.split("->")[1]))
                    for(var i=0; i<model.count; i++) {
                        if(model.get(i).name === lastAction.split("->")[1])
                            model.remove(i)
                    }
                }
            }
        }
    }
    
    TraktShowWatchlist {
        id: userWatchlistShowsModel
        username: traktLogin.contents.username
        password: traktLogin.contents.password
        lastUpdated: Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")
        lastAction: watchlistActivityDocument.contents.show
        onPasswordChanged: {
            console.log("[LOG]: Retrieving user tv show watchlist")
            fetchData(username, password)
        }
        onLastActionChanged: {
            // Update user watchlist only if user is logged in and this action has not been exectued a second ago
            if(username !== "" && lastUpdated !== Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")) {
                lastUpdated = Qt.formatDateTime(new Date(), "yyyyMMdd hh:mm:ss")
                // If show is added to watchlist, update list data from Trakt
                if(lastAction.split("->")[0] === "Added") {
                    console.log("[LOG]: Retrieving user tv show watchlist")
                    fetchData(username, password)
                }
                // If show is removed from watchlist, remove it from the model locally
                else if(lastAction.split("->")[0] === "Removed"){
                    console.log("[LOG]: Removing %1 from the user tv show watchlist (locally)".arg(lastAction.split("->")[1]))
                    for(var i=0; i<model.count; i++) {
                        if(model.get(i).name === lastAction.split("->")[1])
                            model.remove(i)
                    }
                }
            }
        }
    }

    /*
      Phone and Tablet UI Definitions
     */
    Layouts {
        id: tvLayout
        anchors.fill: parent

        layouts: [
            TvTabTablet {}
        ]

        LoadingIndicator {
            isShown: trendingShowsModel.loading || userWatchlistShowsModel.loading || airingShowsModel.loading && tvTab.state !== "search"
        }

        Flickable {
            id: flickable
            clip: true
            anchors.fill: parent
            contentHeight: mainColumn.height + units.gu(5)

            Column {
                id: mainColumn

                anchors {
                    left: parent.left;
                    right: parent.right;
                    top: parent.top;
                }

                spacing: units.gu(1)

                DetailCarousel {
                    id: airingShows
                    dataModel: airingShowsModel.model
                    header: i18n.tr("Upcoming Episodes")
                    visible: traktLogin.contents.status !== "disabled" && airingShowsModel.count > 0
                    onThumbClicked: pageStack.push(Qt.resolvedUrl("EpisodePage.qml"), {"tv_id": model.id, "season_number": model.season, "episode_number": model.episode, "watched": model.watched})
                }

                Carousel {
                    id: userLibrary
                    dataModel: userWatchlistShowsModel.model
                    visible: traktLogin.contents.status !== "disabled" && userWatchlistShowsModel.count > 0
                    header: i18n.tr("Your TV Show Watchlist")
                    onThumbClicked: pageStack.push(Qt.resolvedUrl("TvPage.qml"), {"tv_id": model.id})
                }

                Carousel {
                    id: trending
                    dataModel: trendingShowsModel.model
                    header: i18n.tr("Trending TV Shows")
                    onThumbClicked: pageStack.push(Qt.resolvedUrl("TvPage.qml"), {"tv_id": model.id})
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

                type: "tv"
                search_model: search_results
                onResultClicked: pageStack.push(Qt.resolvedUrl("TvPage.qml"), {"tv_id": model.id})

                Shows {
                    id: search_results
                }
            }
        }
    }

    Action {
        id: searchTvAction
        text: i18n.tr("Tv Show")
        keywords: i18n.tr("Search;Tv;Show;Shows;Find")
        description: i18n.tr("Search for Tv Shows")
        iconName: "search"
        onTriggered: {
            tvTab.state = "search"
            searchField.forceActiveFocus()
            flickable.visible = false
            searchPageLoader.sourceComponent = searchPageComponent
        }
    }

    state: "default"
    states: [
        PageHeadState {
            name: "default"
            head: tvTab.head
            actions: [
                searchTvAction,
                appSettingsAction
            ]
        },

        PageHeadState {
            name: "search"
            head: tvTab.head
            backAction: Action {
                iconName: "back"
                text: i18n.tr("Back")
                onTriggered: {
                    tvTab.state = "default"
                    flickable.visible = true
                    searchField.text = ""
                    searchPageLoader.sourceComponent = undefined
                }
            }

            contents: SearchBox {
                id: searchField
                defaultText: i18n.tr("Search TV Show")
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
                        searchPageLoader.item.search_model.source = Backend.searchUrl(searchPageLoader.item.type, searchField.search_term);
                        if (searchPageLoader.item.type === "tv") {
                            searchPageLoader.item.search_model.createMessage(traktLogin.contents.username, traktLogin.contents.password)
                            searchPageLoader.item.search_model.sendMessage()
                        }
                    }
                }
            }
        }
    ]
}
