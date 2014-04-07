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
import "../backend/backend.js" as Backend
import "../components"
import "../models"

Page {
    id: traktCheckInPage

    visible: false
    flickable: null

    // Properties to hold the movie/episode details respectively
    property string id
    property string movieTitle
    property string episodeTitle
    property string year
    property string season
    property string episode

    // Property to allow for triggering signal in the parent episode page
    property var episodePage

    // Property to allow for triggering signal in the parent movie page
    property var moviePage

    property string type

    LoadingIndicator {
        id: checkInLoader
        loadingText: i18n.tr("Checking-in. Please wait..")
        visible: false
    }

    Notification { id: checkInNotification }

    TraktCheckIn {
        id: traktCheckIn
        function updateJSONModel() {
            checkInLoader.visible = false
            if (reply.status === "success") {
                if(type === "Episode")
                    episodePage.episodeSeen()
                else if(type === "Movie")
                    moviePage.isMovieSeen = true
                userActivityLoader.item.getUserActivityOnline()
                pageStack.pop()
            }
            else if (reply.status === "failure"){
                checkInNotification.messageTitle = type + " " + i18n.tr("Check-in Failed")
                checkInNotification.message = reply.error
                checkInNotification.visible = true
            }
        }
    }

    Flickable {
        id: flickable
        anchors {
            top: parent.top
            bottom: buttonRow.top
            left: parent.left
            right: parent.right
            bottomMargin: units.gu(2)
        }

        contentHeight: detailsColumn.height + units.gu(10)

        Column {
            id: detailsColumn
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: units.gu(4)
            }
            height: childrenRect.height
            spacing: units.gu(2)

            UbuntuShape {
                id: logo
                width: traktCheckInPage.height > units.gu(60) ? units.gu(20) : units.gu(10)
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                image: Image {
                    source: Qt.resolvedUrl("../graphics/trakt_logo.png")
                    fillMode: Image.PreserveAspectFit
                }

                Behavior on width {
                    UbuntuNumberAnimation { duration: UbuntuAnimation.BriskDuration }
                }
            }

            Label {
                text: "Check-in"
                fontSize: "x-large"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            TextArea {
                id: checkinMessage
                placeholderText: i18n.tr("Check-in review (Optional)")
                anchors.horizontalCenter: parent.horizontalCenter
                height: traktCheckInPage.height/4
                width: traktCheckInPage.width/1.5

                Behavior on width {
                    UbuntuNumberAnimation { duration: UbuntuAnimation.BriskDuration }
                }

                Behavior on height {
                    UbuntuNumberAnimation { duration: UbuntuAnimation.BriskDuration }
                }
            }
        }
    }

    Row {
        id: buttonRow
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: traktCheckInPage.height > units.gu(60) ? units.gu(10) : units.gu(2)
        }

        spacing: units.gu(2)
        width: childrenRect.width
        height: childrenRect.height

        Button {
            id: cancelButton
            color: UbuntuColors.warmGrey
            height: units.gu(5)
            width: loginButton.width
            text: i18n.tr("Cancel")
            onClicked: pageStack.pop()
        }

        Button {
            id: loginButton
            color: "green"
            height: units.gu(5)
            width: units.gu(15)
            text: i18n.tr("Check-in")
            onClicked: {
                if (type === "Movie") {
                    traktCheckIn.source = Backend.traktCheckInUrl("movie")
                    traktCheckIn.createMovieMessage(traktLogin.contents.username, traktLogin.contents.password, id, movieTitle, year, checkinMessage.text, pagestack.app_version, pagestack.last_updated)
                    traktCheckIn.sendMessage()
                }
                else if(type === "Episode") {
                    traktCheckIn.source = Backend.traktCheckInUrl("show")
                    traktCheckIn.createEpisodeMessage(traktLogin.contents.username, traktLogin.contents.password, id, episodeTitle, year, season, episode, checkinMessage.text, pagestack.app_version, pagestack.last_updated)
                    traktCheckIn.sendMessage()
                }
                checkInLoader.visible = true
            }
        }
    }

    // A custom toolbar is used in this page
    tools: ToolbarItems {
        locked: true
        opened: false
    }
}
