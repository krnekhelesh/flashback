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
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../backend/backend.js" as Backend
import "../components"
import "../models"

Page {
    id: traktCheckInPage

    visible: false
    flickable: null

    // Page Background
    Background {}

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

    // Disable automatic orientation during walkthough and enable it after the checkin
    Component.onCompleted: mainView.automaticOrientation = false
    Component.onDestruction: mainView.automaticOrientation = true

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
            fill: parent
            bottomMargin: units.gu(2)
        }

        contentHeight: detailsColumn.height

        Column {
            id: detailsColumn
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: units.gu(2)
                topMargin: Qt.inputMethod.visible ? units.gu(2) : units.gu(8)
            }
            height: childrenRect.height
            spacing: Qt.inputMethod.visible ? units.gu(2) : units.gu(8)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: traktCheckInPage.height > units.gu(60) ? units.gu(20) : units.gu(10)
                source: Qt.resolvedUrl("../graphics/checkin.png")
                fillMode: Image.PreserveAspectFit

                Behavior on width {
                    UbuntuNumberAnimation { duration: UbuntuAnimation.BriskDuration }
                }
            }

            SettingsItem {
                title: "Check in"
                contents: [
                    TextArea {
                        id: checkinMessage
                        placeholderText: i18n.tr("Check-in review (Optional)")
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: units.gu(1)
                        height: units.gu(10)
                    }
                ]
            }

            Row {
                id: buttonRow

                anchors.horizontalCenter: parent.horizontalCenter
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
        }
    }
}
