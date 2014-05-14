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
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {
    id: tvPage

    visible: false
    flickable: null

    property string tv_id
    property int userVote: 0
    property bool isShowWatchlisted

    actions: [
        Action {
            id: seeEpisodeGuideAction
            text: i18n.tr("Episode Guide")
            keywords: i18n.tr("See;Episode;Guide;Guides;Episodes")
            description: i18n.tr("See Episode Guide")
            iconSource: Qt.resolvedUrl("../graphics/guide.png")
            onTriggered: pageStack.push(Qt.resolvedUrl("TvSeasons.qml"), {"title": i18n.tr("Episode Guide"), "dataModel": tvSeasons.model, "tv_id": tv_id, "imdb_id": show.imdb_id, "name": show.name, "year": show.year})
        },

        TraktAction {
            id: shareShowAction
            onTriggered: PopupUtils.open(sharePopoverComponent, shareShow)
        }
    ]

    // Page Background
    Background {}

    TraktSeen {
        id: showSee
        function updateJSONModel() {
            if(reply.status === "success") {
                loadingIndicator.isShown = false
                console.log("[LOG]: Show watch success")
            }
        }
    }

    TraktWatchlist {
        id: showWatchlist
        function updateJSONModel() {
            if(reply.status === "success") {
                loadingIndicator.isShown = false
                var tempData = watchlistActivityDocument.contents
                if(!isShowWatchlisted) {
                    console.log("[LOG]: Show watchlist success")
                    isShowWatchlisted = true
                    tempData.show = "Added->" + show.attributes.name
                }
                else {
                    console.log("[LOG]: Show Unwatchlist success")
                    isShowWatchlisted = false
                    tempData.show = "Removed->" + show.attributes.name
                }
                watchlistActivityDocument.contents = tempData
            }
        }
    }

    LoadingIndicator {
        id: loadingIndicator
        isShown: tvCast.loading ||
                 tvSeasons.loading ||
                 show.loading
    }

    Component {
        id: sharePopoverComponent
        TraktPopup {
            showCheckInAction: false
            seenMessage: i18n.tr("Mark show as seen")
            watchlistMessage: isShowWatchlisted ? i18n.tr("Remove show from watchlist") : i18n.tr("Add show to watchlist")
            onWatched: {
                loadingIndicator.loadingText = i18n.tr("Marking show as seen")
                loadingIndicator.isShown = true
                showSee.source = Backend.traktSeenUrl("show")
                showSee.createShowMessage(traktLogin.contents.username, traktLogin.contents.password, tv_id, show.imdb_id, show.name, show.year)
                showSee.sendMessage()
            }
            onWatchlisted:  {
                loadingIndicator.loadingText = !isShowWatchlisted ? i18n.tr("Adding show to watchlist") : i18n.tr("Removing show from watchlist")
                loadingIndicator.isShown = true
                if(!isShowWatchlisted) {
                    showWatchlist.source = Backend.traktWatchlistUrl("show")
                    showWatchlist.createShowMessage(traktLogin.contents.username, traktLogin.contents.password, tv_id, show.name, show.year)
                }
                else {
                    showWatchlist.source = Backend.traktUnwatchlistUrl("show")
                    showWatchlist.createShowMessage(traktLogin.contents.username, traktLogin.contents.password, tv_id, show.name, show.year)
                }
                showWatchlist.sendMessage()
            }
            onCommented: pagestack.push(Qt.resolvedUrl("CommentsPage.qml"), {id: tv_id, type: "Show", name: show.name, year: show.year})
        }
    }

    TraktCast { id: tvCast }

    ShowSeasons {
        id: tvSeasons
        source: Backend.tvSeasons(tv_id)
    }

    Show {
        id: show
        username: traktLogin.contents.username
        password: traktLogin.contents.password
        onPasswordChanged: {
            source = Backend.tvUrl(tv_id)
            createMessage(username, password)
            sendMessage()
        }
        onUpdated: {
            tvCast.json = show.attributes.creditsJson;
            if(traktLogin.contents.status !== "disabled") {
                userVote = show.attributes.userVote
                isShowWatchlisted = show.attributes.in_watchlist
            }
        }
    }

    RatingChooser {
        id: userRatingDialog
        z: tvThumb.z + 1
        type: "show"
        type_id: tv_id
        name: show.attributes.name
        year: show.attributes.year
        onRatingClicked: userVote = userRatingDialog.ratings
        anchors.centerIn: parent
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: tvThumb.height + ratingsRow.height + detailsColumn.height + units.gu(10)
        interactive: contentHeight > parent.height

        Behavior on contentY {
            UbuntuNumberAnimation { target: flickable; property: "contentY"; duration: UbuntuAnimation.SlowDuration }
        }

        Thumbnail {
            id: tvThumb
            width: units.gu(18)
            height: width + units.gu(10)
            thumbSource: show.attributes.thumb_url
            anchors {
                top: parent.top
                left: parent.left
                margins: units.gu(2)
            }
        }

        Label {
            id: name
            text: show.attributes.name
            fontSize: "large"
            width: tvColumn.width
            maximumLineCount: 2
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            anchors {
                top: parent.top
                left: tvThumb.right
                right: parent.right
                leftMargin: units.gu(2)
                rightMargin: units.gu(2)
                topMargin: units.gu(2)
            }
        }

        Rotater {
            id: overviewContainer

            flipHeight: tvPage.height
            height: tvThumb.height/5
            anchors {
                top: name.bottom
                left: name.left
                right: name.right
                topMargin: units.gu(2)
            }

            visible: show.attributes.overview

            onFlippedChanged: {
                if (!overviewContainer.flipped)
                    flickable.interactive =  flickable.contentHeight > tvPage.height
                else
                    flickable.interactive = false
            }

            front: Label {
                id: overview
                text: show.attributes.overview
                fontSize: "medium"
                anchors.fill: parent
                elide: Text.ElideRight
                wrapMode: Text.WordWrap

                MouseArea {
                    anchors.fill: parent
                    enabled: {
                        if (!overviewContainer.flipped)
                            if(overview.truncated)
                                return true
                            else
                                return false
                        else
                            return false
                    }
                    onClicked: {
                        overviewContainer.flipped = !overviewContainer.flipped

                        if(!flickable.atYBeginning)
                            flickable.contentY = 0
                    }
                }
            }

            back: Rectangle {
                color: "Transparent"
                anchors.fill: parent

                Background{}

                Flickable {
                    id: summaryFlickable
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: mainColumn.height > parent.height ? mainColumn.height + units.gu(10) : parent.height
                    interactive: contentHeight > parent.height

                    Column {
                        id: mainColumn
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            margins: units.gu(2)
                        }

                        spacing: units.gu(2)

                        Label {
                            id: header
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: i18n.tr("Full Summary")
                            fontSize: "x-large"
                        }

                        Label {
                            id: fullOverview
                            text: show.attributes.overview
                            visible: show.attributes.overview
                            fontSize: "medium"
                            anchors {
                                left: parent.left
                                right: parent.right
                            }

                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: overviewContainer.flipped
                        onClicked: overviewContainer.flipped = !overviewContainer.flipped
                    }
                }
            }
        }

        Column {
            id: tvColumn
            anchors {
                left: name.left
                right: name.right
                bottom: tvThumb.bottom
            }
            spacing: units.gu(1)

            ImageLabel {
                id: networks
                image: Qt.resolvedUrl("../graphics/network.png")
                size: units.gu(2)
                label: show.attributes.networks
                visible: show.attributes.networks != ''
            }

            ImageLabel {
                id: firstAir
                image: Qt.resolvedUrl("../graphics/calendar.png")
                size: units.gu(2)
                label: show.attributes.year
                visible: show.attributes.year > 0
            }

            ImageLabel {
                image: Qt.resolvedUrl("../graphics/list.png")
                size: units.gu(2)
                label: tvSeasons.model.count-1 + " " + i18n.tr("Seasons")
                visible: tvSeasons.model.count > 0
            }

            ImageLabel {
                image: Qt.resolvedUrl("../graphics/time.png")
                size: units.gu(2)
                label: show.attributes.air_day_utc + " | " + show.attributes.air_time_utc
                visible: show.attributes.air_day_utc !== '' || show.attributes.air_time_utc !== ''
            }

            ImageLabel {
                image: Qt.resolvedUrl("../graphics/duration.png")
                size: units.gu(2)
                label: formatDuration(show.attributes.episode_run_time)
                visible: show.attributes.episode_run_time > 0

                function formatDuration(time) {
                    var hours = Math.floor(time / 60)
                    var minutes = time % 60
                    if (hours === 0)
                        return minutes + " minutes"
                    else if (hours === 1 && minutes === 0)
                        return hours + " hour"
                    else if (hours > 1 && minutes === 0)
                        return hours + " hours"
                    else if(hours === 1 && minutes !== 0)
                        return hours + " hr " + minutes + " mins"
                    else
                        return hours + " hrs " + minutes + " mins"
                }
            }
        }

        // Ratings Row
        TraktRating {
            id: ratingsRow
            visible: show.attributes.voteCount > 0
            rating: "%1%\n%2 votes".arg(show.attributes.voteAverage).arg(show.attributes.voteCount)
            personalIcon: Qt.resolvedUrl("../graphics/heart-" + userVote + ".png")
            personal: traktLogin.contents.status !== "disabled" ? (userVote !== 0 ? userVote + "/10" : i18n.tr("Rate This")) : i18n.tr("Authenticate\nTrakt to rate")
            onClicked: traktLogin.contents.status !== "disabled" ? userRatingDialog.visible = true : pagestack.push(Qt.resolvedUrl("../ui/Trakt.qml"))
            anchors {
                top: tvColumn.bottom
                left: parent.left
                right: parent.right
                topMargin: units.gu(4)
                margins: units.gu(2)
            }
        }

        // Tv Details - Release dates, genre, movie theme etc.
        Column {
            id: detailsColumn
            anchors {
                left: parent.left
                right: parent.right
                top: ratingsRow.bottom
                topMargin: units.gu(2)
            }

            ListItem.Header { text: i18n.tr("Details") }

            ListItem.Subtitled {
                text: i18n.tr("Status")
                subText: show.attributes.in_production === "Continuing" ? "<font color='lightgreen'>" + i18n.tr("Continuing") + "</font>" : "<font color='orange'>" + i18n.tr("Ended") + "</font>"
                visible: show.attributes.in_production !== undefined
            }

            ListItem.MultiValue {
                id: genres
                text: i18n.tr("Genres")
                values: show.attributes.genres.map(function(o) { return o })
                visible: show.attributes.genres.length > 0
            }

            ListItem.Subtitled {
                id: releaseDate
                text: i18n.tr("First Air Date")
                subText: Qt.formatDate(new Date(show.attributes.first_air_date*1000), 'dd MMMM yyyy')
                visible: show.attributes.first_air_date
            }

            ListItem.Header { text: i18n.tr("Casts") }

            Repeater {
                model: (tvCast.count > 3 ? 3 : tvCast.count)
                delegate: ListItem.Subtitled {
                    text: tvCast.model.get(index).name
                    iconSource: tvCast.model.get(index).thumb_url
                    subText: tvCast.model.get(index).character
                }
            }

            ListItem.Standard {
                id: allCast
                text: i18n.tr("Full Cast")
                progression: true
                onClicked: pageStack.push(Qt.resolvedUrl("CastPage.qml"), {"title": i18n.tr("Full Cast"), "dataModel": tvCast.model, "getActorDetail": false})
            }
        }
    }

    tools: ToolbarItems {
        id: toolbarTv

        ToolbarButton {
            id: returnHome
            visible: pageStack.depth > 2
            action: returnHomeAction
        }

        ToolbarButton {
            id: shareShow
            action: shareShowAction
        }

        ToolbarButton {
            id: seeEpisodeGuides
            action: seeEpisodeGuideAction
        }
    }
}
