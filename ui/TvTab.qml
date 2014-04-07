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
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {
    flickable: null

    Component.onCompleted: console.log("[LOG]: TV Tab Loaded")

    actions: [
        Action {
            id: searchTvAction
            text: i18n.tr("Tv Show")
            keywords: i18n.tr("Search;Tv;Show;Shows;Find")
            description: i18n.tr("Search for Tv Shows")
            iconSource: Qt.resolvedUrl("../graphics/find.svg")
            onTriggered: pageStack.push(Qt.resolvedUrl("SearchTv.qml"))
        }
    ]

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

    LoadingIndicator {
        visible: !trending.visible
    }

    Flickable {
        clip: true
        anchors.fill: parent
        contentHeight: mainColumn.height + units.gu(5)

        Column {
            id: mainColumn

            anchors {
                left: parent.left;
                right: parent.right;
                top: parent.top;
                margins: units.gu(1)
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

    tools: ToolbarItems {
        id: toolbarTv

        ToolbarButton {
            id: settings
            action: appSettingsAction
        }

        ToolbarButton {
            id: searchTv
            action: searchTvAction
        }
    }
}
