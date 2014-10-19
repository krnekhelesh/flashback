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
import "../components"

Page {
    id: traktPage

    title: "Trakt"

    visible: false
    flickable: null

    // Page Background
    Background {}

    // Function to logout of the trakt user account
    function logout() {
        traktLogin.contents = {
            username: "johnDoe",
            password: "password",
            status: "disabled"
        }
    }

    Flickable {
        id: flickable
        clip: true
        anchors.fill: parent
        contentHeight: detailsColumn.height + units.gu(10)
        interactive: contentHeight > parent.height

        Column {
            id: detailsColumn
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: units.gu(2)
            }

            spacing: units.gu(4)

            Label {
                text: i18n.tr("Track what you're watching. Discover new shows & movies.")
                fontSize: "large"
                width: parent.width
                wrapMode: Text.WordWrap
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: i18n.tr("Trakt is a platform that does many things, but primarily keeps track of TV shows and movies you watch. It integrates with your media center or home theater PC to enable scrobbling, so everything is automatic.
                       \nBy authenticating into Trakt, you get the following additional features.\n - Check-in and rate movies\n - Keep track of watched movies
 - Discover new movies\n - Add movies to your watchlist\n - Keep data synced across devices using Trakt")
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gu(2)

                Button {
                    height: units.gu(5)
                    width: units.gu(15)
                    text: traktLogin.contents.status === "disabled" ? i18n.tr("Log in") : i18n.tr("Log out")
                    color: traktLogin.contents.status === "disabled" ? "Green" : UbuntuColors.orange
                    onClicked: traktLogin.contents.status === "disabled" ? pagestack.push(Qt.resolvedUrl("TraktLogin.qml"), {"isLogin": true}) : logout()
                }

                Button {
                    color: "Orange"
                    height: units.gu(5)
                    width: units.gu(15)
                    text: i18n.tr("Sign up")
                    visible: traktLogin.contents.status === "disabled"
                    onClicked: pagestack.push(Qt.resolvedUrl("TraktLogin.qml"), {"isLogin": false})
                }
            }
        }
    }
}
