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

import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../backend/backend.js" as Backend
import "../components"
import "../models"

Page {
    id: seasonPage

    visible: false
    flickable: null
    title: season_number === "0" ? "Season Specials" : "Season " + season_number

    property string season_number
    property string season_poster
    property string tv_id
    property string imdb_id
    property string name
    property string year

    property int watched_count: 0
    property bool isSeasonSeen: false
    property int currentSeenEpisode: -1
    property alias episodeModel: episodes.model
    property bool isAuthenticated: traktLogin.contents.status !== "disabled"

    signal watched()

    onWatched: {
        watched_count = 0
        if(traktLogin.contents.status !== "disabled") {
            for (var i=0; i<episodes.model.count; i++) {
                if(episodes.model.get(i).watched === "true")
                    watched_count = watched_count + 1;
            }
        }
    }

    onWatched_countChanged: {
        if(watched_count === episodes.model.count)
            isSeasonSeen = true
        else
            isSeasonSeen = false
    }

    LoadingIndicator {
        id: loadingIndicator
        isShown: episodes.loading
    }

    Action {
        id: authenticateAction
        text: i18n.tr("Login into Trakt")
        visible: !isAuthenticated
        iconSource: Qt.resolvedUrl("../graphics/user_white.png")
        onTriggered: pagestack.push(Qt.resolvedUrl("Trakt.qml"))
    }

    Action {
        id: watchedAction
        visible: isAuthenticated
        text: isSeasonSeen ? i18n.tr("Mark unseen") : i18n.tr("Mark seen")
        iconSource: isSeasonSeen ? Qt.resolvedUrl("../graphics/watched_red.png") : Qt.resolvedUrl("../graphics/watched_green.png")
        onTriggered: {
            if(!isSeasonSeen) {
                loadingIndicator.loadingText = i18n.tr("Marking season as seen")
                loadingIndicator.isShown = true
                seasonSee.source = Backend.traktSeenUrl("show/season")
                seasonSee.createSeasonMessage(traktLogin.contents.username, traktLogin.contents.password, tv_id, imdb_id, name, year, season_number)
                seasonSee.sendMessage()
            }
        }
    }

    head.actions: [
        returnHomeAction,
        authenticateAction,
        watchedAction
    ]

    // Page Background
    Background {}

    TraktSeen {
        id: seasonSee
        function updateJSONModel() {
            if(reply.status === "success") {
                loadingIndicator.isShown = false
                console.log("[LOG]: Season watch success")
                watched_count = episodes.model.count
                for (var i=0; i<episodes.model.count; i++) {
                    episodes.model.setProperty(i, "watched", "true")
                }
            }
        }
    }

    TraktSeen {
        id: episodeSee
        function updateJSONModel() {
            if(reply.status === "success") {
                loadingIndicator.isShown = false
                console.log("[LOG]: Episode watch success")
                watched_count = watched_count + 1
                episodes.model.setProperty(currentSeenEpisode, "watched", "true")
                episodeSeenActivityDocument.contents = {
                    episode: "Seen->" + episodes.model.get(currentSeenEpisode).episode_name
                }
            }
        }
    }

    TraktSeen {
        id: episodeUnsee
        function updateJSONModel() {
            if(reply.status === "success") {
                loadingIndicator.isShown = false
                console.log("[LOG]: Episode unwatch success")
                watched_count = watched_count - 1
                episodes.model.setProperty(currentSeenEpisode, "watched", "false")
            }
        }
    }

    SeasonEpisodes {
        id: episodes
        source: Backend.tvSeasonUrl(tv_id, season_number)
        onUpdated: watched()
        Component.onCompleted: {
            episodes.createMessage(traktLogin.contents.username, traktLogin.contents.password)
            episodes.sendMessage()
        }
    }

    Flickable {
        id: flickable

        clip: true
        anchors.fill: parent
        contentHeight: seasonThumb.height + detailsColumn.height + units.gu(10)
        interactive: contentHeight > parent.height

        Thumbnail {
            id: seasonThumb
            width: units.gu(18)
            height: width + units.gu(10)
            thumbSource: season_poster
            anchors {
                top: parent.top
                left: parent.left
                margins: units.gu(2)
            }
        }

        Label {
            id: totalEpisodeCount
            text: "Episode count: " + episodes.model.count
            anchors {
                top: parent.top
                left: seasonThumb.right
                right: parent.right
                leftMargin: units.gu(2)
                rightMargin: units.gu(2)
                topMargin: units.gu(2)
            }
        }

        Label {
            id: watchedEpisodeCount
            text: "Episodes watched: " + watched_count
            visible: traktLogin.contents.status !== "disabled"
            anchors {
                top: totalEpisodeCount.bottom
                topMargin: units.gu(0)
                left: totalEpisodeCount.left
                right: totalEpisodeCount.right
            }
        }

        ProgressBar {
            id: userProgress
            maximumValue: episodes.model.count
            minimumValue: 0
            value: watched_count
            visible: episodes.model.count > 0 && traktLogin.contents.status !== "disabled"
            height: units.gu(3)
            anchors {
                top: watchedEpisodeCount.bottom
                left: totalEpisodeCount.left
                right: totalEpisodeCount.right
                topMargin: units.gu(1)
            }
        }

        Column {
            id: detailsColumn
            anchors {
                left: parent.left
                right: parent.right
                top: seasonThumb.bottom
                topMargin: units.gu(2)
            }
            Repeater {
                id: episodeList
                model: episodes.count
                delegate: Item {
                    height: episodeItem.height
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    ListItem.Subtitled {
                        id: episodeItem
                        showDivider: true
                        text: episodes.model.get(index).episode_name
                        iconSource: episodes.model.get(index).thumb_url
                        subText: i18n.tr("Episode") + " " + episodes.model.get(index).episode
                        onClicked: pageStack.push(Qt.resolvedUrl("EpisodePage.qml"), {"seasonDetailsPage": seasonPage, "tv_id": tv_id, "season_number": season_number, "episode_number": episodes.model.get(index).episode, "watched": episodes.model.get(index).watched})
                    }

                    Image {
                        id: watchedStatus
                        width: units.gu(3)
                        height: width
                        source: Qt.resolvedUrl("../graphics/watched.png")
                        visible: traktLogin.contents.status !== "disabled"
                        opacity: episodes.model.get(index).watched === "true" ? 1.0 : 0.1
                        anchors {
                            right: parent.right
                            rightMargin: units.gu(2)
                            verticalCenter: parent.verticalCenter
                        }
                        MouseArea {
                            anchors.fill: parent
                            preventStealing: true
                            onClicked: {
                                currentSeenEpisode = index
                                if(episodes.model.get(index).watched === "true") {
                                    loadingIndicator.loadingText = i18n.tr("Marking episodes as unseen")
                                    loadingIndicator.isShown = true
                                    episodeUnsee.source = Backend.cancelTraktSeen("show/episode")
                                    episodeUnsee.createEpisodeMessage(traktLogin.contents.username, traktLogin.contents.password, tv_id, imdb_id, name, year, season_number, episodes.model.get(index).episode)
                                    episodeUnsee.sendMessage()
                                }
                                else {
                                    loadingIndicator.loadingText = i18n.tr("Marking episodes as seen")
                                    loadingIndicator.isShown = true
                                    episodes.model.setProperty(index, "watched", "true")
                                    episodeSee.source = Backend.traktSeenUrl("show/episode")
                                    episodeSee.createEpisodeMessage(traktLogin.contents.username, traktLogin.contents.password, tv_id, imdb_id, name, year, season_number, episodes.model.get(index).episode)
                                    episodeSee.sendMessage()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
