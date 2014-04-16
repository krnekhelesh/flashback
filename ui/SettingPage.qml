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

Page {
    id: settings

    visible: false
    flickable: flickable
    title: i18n.tr("Settings")

    ListModel {
        id: webserviceModel
        ListElement {
            name: "Trakt"
            thumb_url: "../graphics/trakt_logo.png"
            link: "Trakt.qml"
            db_doc: "traktLogin"
        }
    }

    Flickable {
        id: flickable
        clip: true
        anchors.fill: parent
        contentHeight: mainColumn.height + units.gu(5)

        Column {
            id: mainColumn
            spacing: units.gu(2)
            height: childrenRect.height
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: units.gu(2)
            }

            SettingsItem {
                title: "Web Services"
                contents: [
                    Subtitled {
                        text: "Trakt"
                        subText: traktLogin.contents.status === "disabled" ? i18n.tr("Not Authenticated") : "<font color='green'>" + i18n.tr("Authenticated") + "</font>"
                        iconSource: Qt.resolvedUrl("../graphics/trakt_logo.png")
                        progression: true
                        showDivider: false
                        onClicked: pagestack.push(Qt.resolvedUrl("Trakt.qml"))
                    }
                ]
            }

            SettingsItem {
                id: help
                title: "Help"
                contents: [
                    Standard {
                        text: i18n.tr("Show First Run Tutorial")
                        iconFrame: false
                        showDivider: false
                        progression: true
                        iconSource: Qt.resolvedUrl("../graphics/help.png")
                        onClicked: pagestack.push(Qt.resolvedUrl("../walkthrough/FirstRunWalkthrough.qml"), {"isFirstRun": false})
                    }
                ]
            }

            SettingsItem {
                id: about
                title: "About"
                contents: [
                    Standard {
                        text: i18n.tr("Credits")
                        iconFrame: false
                        progression: true
                        iconSource: Qt.resolvedUrl("../graphics/credits.png")
                        onClicked: pagestack.push(Qt.resolvedUrl("About.qml"))
                    },

                    Standard {
                        text: i18n.tr("Tweet us!")
                        iconFrame: false
                        progression: true
                        iconSource: Qt.resolvedUrl("../graphics/twitter_logo.png")
                        onClicked: Qt.openUrlExternally("http://twitter.com/home?status=Checkout the Flashback app! It allows you to track Tv Shows and Movies. Get it for your Ubuntu phone at https://launchpad.net/cliffhanger")
                    },

                    Standard {
                        text: i18n.tr("Facebook us!")
                        showDivider: false
                        iconFrame: false
                        progression: true
                        iconSource: Qt.resolvedUrl("../graphics/facebook_logo.png")
                        onClicked: Qt.openUrlExternally("https://www.facebook.com/sharer/sharer.php?s=100&p%5Btitle%5D=Flashback+for+Ubuntu&p%5Bsummary%5D=An+app+for+tracking+Tv+Shows+and+Movies&p[url]=https://launchpad.net/cliffhanger")
                    }
                ]
            }

            SettingsItem {
                title: "Version"
                contents: [
                    Subtitled {
                        text: pagestack.app_name + " " + pagestack.app_version
                        subText: i18n.tr("Thank you for downloading. Enjoy!")
                        iconSource: Qt.resolvedUrl("../flashback.png")
                        showDivider: false
                    }
                ]
            }

            SettingsItem {
                title: "Disclaimer"
                contents: [
                    Standard {
                        text: i18n.tr("This product uses the TMDb API but is not\nendorsed or certified by TMDb.")
                        showDivider: false
                    },

                    Standard {
                        text: "<b>" + i18n.tr("Click here to report a bug") + "</b><br>Copyright (C) 2014 Flashback Dev Team"
                        showDivider: false
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.openUrlExternally("https://bugs.launchpad.net/cliffhanger/+filebug")
                        }
                    }
                ]
            }
        }
    }
}
