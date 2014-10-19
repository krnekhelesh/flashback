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
import Ubuntu.Components.Popups 1.0
import "../backend/backend.js" as Backend
import "../components"
import "../models"

Page {
    id: episodePage

    visible: false
    flickable: null
    title: i18n.tr("TV Show")

    // Properties received from other pages to retrieve episode info
    property string season_number
    property string episode_number
    property string tv_id

    property bool isAuthenticated: traktLogin.contents.status !== "disabled"

    property int userVote: 0

    /*
       Property received from outside to determine the watched status of an episode. This is sent
       rather than retrieved online since it has found to receive wrong values sometimes in the case
       of a check-in. Hence to avoid that bug, this is sent by the parent page like the season details
       page.
     */
    property string watched

    // Property received from other pages to pass back data (optional)
    property var seasonDetailsPage: undefined

    // Property to hold the seen status of an episode
    property bool isEpisodeSeen

    // Signals triggered on marking an episode as seen/unseen
    signal episodeSeen()
    signal episodeUnseen()

    onEpisodeSeen: {
        isEpisodeSeen = true
        if(seasonDetailsPage !== undefined && seasonDetailsPage.episodeModel.get(episode_number-1).watched !== "true") {
            seasonDetailsPage.watched_count = seasonDetailsPage.watched_count + 1
            seasonDetailsPage.episodeModel.setProperty(episode_number-1, "watched", "true")
        }
    }

    onEpisodeUnseen: {
        isEpisodeSeen = false
        if(seasonDetailsPage !== undefined && seasonDetailsPage.episodeModel.get(episode_number-1).watched !== "false") {
            seasonDetailsPage.watched_count = seasonDetailsPage.watched_count - 1
            seasonDetailsPage.episodeModel.setProperty(episode_number-1, "watched", "false")
        }
    }

    // Page Background
    Background {}

    TraktSeen {
        id: episodeSee
        function updateJSONModel() {
            if(reply.status === "success") {
                loadingIndicator.isShown = false
                console.log("[LOG]: Episode watch success")
                episodeSeen()
                episodeSeenActivityDocument.contents = {
                    episode: "Seen->" + episodeDetails.attributes.episode_name
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
                episodeUnseen()
            }
        }
    }

    BasePostModel {
        id: cancelCheckIn
        function updateJSONModel() {
            if(reply.status === "success") {
                console.log("[LOG]: Episode Check-in cancelled")
                userActivityLoader.item.setDefaultDatabase()
                userActivityLoader.item.getUserActivityOnline()
            }
        }
    }

    RatingChooser {
        id: userRatingDialog
        z: mainColumn.z + 1
        type: "episode"
        type_id: tv_id
        name: episodeDetails.attributes.name
        year: episodeDetails.attributes.year
        season: season_number
        episode: episode_number
        onRatingClicked: userVote = userRatingDialog.ratings
        anchors.centerIn: parent
    }

    Episode {
        id: episodeDetails
        username: traktLogin.contents.username
        password: traktLogin.contents.password
        onPasswordChanged: {
            source = Backend.tvEpisodeUrl(tv_id, season_number, episode_number)
            createMessage(username, password)
            sendMessage()
        }
        onUpdated: {
            if(traktLogin.contents.status !== "disabled") {
                userVote = episodeDetails.attributes.userVote
                if(watched === "true")
                    isEpisodeSeen = true
                else
                    isEpisodeSeen = false
            }
        }
    }

    LoadingIndicator {
        id: loadingIndicator
        isShown: episodeDetails.loading
    }

    head.contents: Label {
        width: parent ? parent.width : undefined
        anchors.verticalCenter: parent ? parent.verticalCenter : undefined
        text: episodeDetails.attributes.name ? episodeDetails.attributes.name : i18n.tr("TV Show")
        fontSize: "x-large"
        maximumLineCount: fontSize === "large" ? 2 : 1
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        onTruncatedChanged: {
            if (truncated) {
                fontSize = "large"
            }
        }
    }

    Action {
        id: authenticateAction
        text: i18n.tr("Login into Trakt")
        visible: !isAuthenticated
        iconSource: Qt.resolvedUrl("../graphics/user_white.png")
        onTriggered: pagestack.push(Qt.resolvedUrl("Trakt.qml"))
    }

    Action {
        id: checkInAction
        visible: isAuthenticated
        text: showActivityDocument.contents.name !== "default" ? i18n.tr("Cancel Check-in") : i18n.tr("Check-in Episode")
        iconSource: Qt.resolvedUrl("../graphics/checkmark.png")
        onTriggered: {
            if(showActivityDocument.contents.name !== "default") {
                cancelCheckIn.source = Backend.cancelTraktCheckIn("show")
                cancelCheckIn.createMessage(traktLogin.contents.username, traktLogin.contents.password)
                cancelCheckIn.sendMessage()
            }
            else
                pagestack.push(Qt.resolvedUrl("../ui/TraktCheckIn.qml"), {episodePage: episodePage, type: "Episode", id: tv_id, episodeTitle: episodeDetails.attributes.name, year: episodeDetails.attributes.year, season: season_number, episode: episode_number})
        }
    }

    Action {
        id: watchedAction
        visible: isAuthenticated
        text: isEpisodeSeen ? i18n.tr("Mark unseen") : i18n.tr("Mark seen")
        iconSource: Qt.resolvedUrl("../graphics/watched.png")
        onTriggered: {
            loadingIndicator.loadingText = isEpisodeSeen ? i18n.tr("Marking episode as unseen") : i18n.tr("Marking episode as seen")
            loadingIndicator.isShown = true
            if(!isEpisodeSeen) {
                episodeSee.source = Backend.traktSeenUrl("show/episode")
                episodeSee.createEpisodeMessage(traktLogin.contents.username, traktLogin.contents.password, episodeDetails.attributes.id, episodeDetails.attributes.imdb_id, episodeDetails.attributes.name, episodeDetails.attributes.year, episodeDetails.attributes.season, episodeDetails.attributes.episode)
                episodeSee.sendMessage()
            }
            else {
                episodeUnsee.source = Backend.cancelTraktSeen("show/episode")
                episodeUnsee.createEpisodeMessage(traktLogin.contents.username, traktLogin.contents.password, episodeDetails.attributes.id, episodeDetails.attributes.imdb_id, episodeDetails.attributes.name, episodeDetails.attributes.year, episodeDetails.attributes.season, episodeDetails.attributes.episode)
                episodeUnsee.sendMessage()
            }
        }
    }

    Action {
        id: commentAction
        text: i18n.tr("View comments")
        iconSource: Qt.resolvedUrl("../graphics/comment_white.png")
        onTriggered: {
            pagestack.push(Qt.resolvedUrl("CommentsPage.qml"), {id: tv_id, type: "Episode", name: episodeDetails.attributes.name, year: episodeDetails.attributes.year, season: season_number, episode: episode_number})
        }
    }

    head.actions: [
        returnHomeAction,
        authenticateAction,
        checkInAction,
        watchedAction,
        commentAction
    ]

    Flickable {
        id: flickable
        clip: true
        anchors.fill: parent
        contentHeight: mainColumn.height + episodeThumb.height + units.gu(10)
        interactive: contentHeight > parent.height

        // Episode thumb. Shown as a background
        Image {
            id: episodeThumb
            height: parent.width/1.5
            sourceSize.width: parent.width
            fillMode: Image.PreserveAspectCrop
            source: episodeDetails.attributes.thumb_url
            smooth: true
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
            }

            ActivityIndicator {
                running: episodeThumb.status !== Image.Ready
                anchors.centerIn: parent
            }
        }

        Column {
            id: mainColumn

            anchors {
                top: episodeThumb.bottom
                left: parent.left
                right: parent.right
                topMargin: units.gu(1)
                leftMargin: units.gu(2)
                rightMargin: units.gu(2)
            }

            spacing: units.gu(4)

            // Container to house the episode title and number
            Column {
                anchors{
                    left: parent.left
                    right: parent.right
                }

                Label {
                    id: name
                    text: episodeDetails.attributes.episode_name
                    fontSize: "large"
                    width: parent.width
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }

                Label {
                    id: episodeNumber
                    fontSize: "medium"
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "S" + season_number + "E" + episode_number
                }
            }

            // Release Date Image Label
            ImageLabel {
                id: releaseDate
                size: units.gu(2)
                anchors.horizontalCenter: parent.horizontalCenter
                image: Qt.resolvedUrl("../graphics/calendar.png")
                label: Qt.formatDate(new Date(episodeDetails.attributes.episode_air_date*1000), 'dd MMMM yyyy')
                visible: episodeDetails.attributes.episode_air_date
            }

            // Ratings Row
            TraktRating {
                id: ratings
                visible: episodeDetails.attributes.voteCount > 0
                rating: "%1%\n%2 votes".arg(episodeDetails.attributes.voteAverage).arg(episodeDetails.attributes.voteCount)
                personalIcon: Qt.resolvedUrl("../graphics/heart-" + userVote + ".png")
                personal: traktLogin.contents.status !== "disabled" ? (userVote !== 0 ? userVote + "/10" : i18n.tr("Rate This")) : i18n.tr("Authenticate\nTrakt to rate")
                onClicked: traktLogin.contents.status !== "disabled" ? userRatingDialog.visible = true : pagestack.push(Qt.resolvedUrl("../ui/Trakt.qml"))
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            // Episode summary
            Label {
                id: fullOverview
                fontSize: "medium"
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
                text: episodeDetails.attributes.overview
                visible: episodeDetails.attributes.overview
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }
}
