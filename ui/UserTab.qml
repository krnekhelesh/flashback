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
import QtGraphicalEffects 1.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {
    id: userTab

    flickable: null

    Component.onCompleted: console.log("[LOG]: TV Tab Loaded")

    actions: [
        Action {
            id: setupAccountAction
            text: i18n.tr("Account")
            keywords: i18n.tr("Setup;Create;Account;Trakt")
            description: i18n.tr("Setup a Trakt Account")
            iconSource: Qt.resolvedUrl("../graphics/add.png")
            onTriggered: pageStack.push(Qt.resolvedUrl("Trakt.qml"))
        },

        Action {
            id: refreshAccountAction
            text: i18n.tr("Refresh")
            keywords: i18n.tr("Reload;Refresh;New;Trakt")
            description: i18n.tr("Refresh Account Information")
            iconName: "reload"
            onTriggered: traktAccountModel.fetchData(traktLogin.contents.username, traktLogin.contents.password)
        }
    ]

    // Page Background
    Background {}

    TraktAccountProfile {
        id: traktAccountModel
        username: traktLogin.contents.username
        password: traktLogin.contents.password
        onPasswordChanged: {
            console.log("[LOG]: Retrieving trakt account details")
            fetchData(username, password)
        }
        function updateJSONModel() {
            if(traktLogin.contents.status !== "disabled") {
                field1.text = reply.full_name ? reply.full_name : reply.username
                field2.text= reply.location ? reply.location
                                            : reply.about ? reply.about
                                                          : reply.url
                stat1.text = reply.stats.friends
                stat2.text = reply.stats.episodes.checkins + reply.stats.movies.checkins

                watchStat1.value = reply.stats.episodes.watched
                watchStat2.value = reply.stats.shows.watched
                watchStat3.value = reply.stats.movies.watched

                rateStat1.value = reply.stats.episodes.loved + reply.stats.episodes.hated
                rateStat2.value = reply.stats.shows.loved + reply.stats.shows.hated
                rateStat3.value = reply.stats.movies.loved + reply.stats.movies.hated

                collectStat1.value = reply.stats.episodes.collection
                collectStat2.value = reply.stats.shows.collection
                collectStat3.value = reply.stats.movies.collection

                _profilePicture.thumbSource = reply.avatar
            }
            else {
                field1.text = "JohnDoe"
                field2.text = "Linux"
                stat1.text = stat2.text = "?"
                watchStat1.value = watchStat2.value = watchStat3.value = "?"
                rateStat1.value = rateStat2.value = rateStat3.value = "?"
                collectStat1.value = collectStat2.value = collectStat3.value = "?"
                _profilePicture.thumbSource = Qt.resolvedUrl("../graphics/no-passport.png")
            }
        }
    }

    LoadingIndicator {
        isShown: traktAccountModel.loading
    }

    EmptyState {
        id: createAccountMessage
        logo: Qt.resolvedUrl("../graphics/account.png")
        header: i18n.tr("No Trakt Account")
        message: i18n.tr("Please first set up a Trakt Account to be able to see your stats.")
        visible: traktLogin.contents.status === "disabled"
    }

    Item {
        id: _background
        z: -1
        width: parent.width
        height: 0.45 * userTab.height
        anchors.top: parent.top
        anchors.topMargin: -units.gu(9)
    }

    Rectangle {
        id: _transparentStrip
        z: _background.z + 1
        width: parent.width
        color: Qt.rgba(0,0,0,0.4)
        height: statRow.height + units.gu(2)
        anchors.bottom: _background.bottom
        visible: traktLogin.contents.status !== "disabled"
    }

    Rectangle {
        id: _whiteStrip
        width: parent.width
        height: field1.height + field2.height + units.gu(2)
        color: "White"
        anchors.top: _background.bottom
        visible: traktLogin.contents.status !== "disabled"
    }

    Thumbnail {
        id: _profilePicture
        width: height
        height: 0.25 * userTab.height
        visible: traktLogin.contents.status !== "disabled"
        anchors {
            left: parent.left
            bottom: _transparentStrip.bottom
            bottomMargin: units.gu(1)
            leftMargin: units.gu(2)
        }
    }

    Column {
        id: profileFieldColumn
        visible: traktLogin.contents.status !== "disabled"
        anchors {
            left: parent.left
            right: parent.right
            margins: units.gu(2)
            verticalCenter: _whiteStrip.verticalCenter
        }
        Label {
            id: field1
            font.bold: true
            fontSize: "large"
            color: UbuntuColors.coolGrey
        }

        Label {
            id: field2
            color: Qt.lighter(UbuntuColors.coolGrey)
            MouseArea {
                enabled: field2.text.indexOf("http://") > -1 ? true : false
                anchors.fill: parent
                onClicked: Qt.openUrlExternally(field2.text)
            }
        }
    }

    Row {
        id: statRow
        height: stat1.height + stat2.height
        visible: traktLogin.contents.status !== "disabled"
        anchors {
            left: _profilePicture.right
            right: parent.right
            margins: units.gu(2)
            verticalCenter: _transparentStrip.verticalCenter
        }

        spacing: units.gu(2)

        Column {
            Label {
                id: stat1
                width: stat1field.contentWidth
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
            }

            Label {
                id: stat1field
                text: "Friends"
            }
        }

        Column {
            Label {
                id: stat2
                width: stat2field.contentWidth
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
            }

            Label {
                id: stat2field
                text: "Check-ins"
            }
        }
    }

    Rectangle {
        width: parent.width
        color: "White"
        anchors.top: _whiteStrip.bottom
        anchors.bottom: parent.bottom
        visible: traktLogin.contents.status !== "disabled"

        Column {
            anchors.fill: parent

            CustomDivider {
                color: "#C0392B"
            }

            Row {
                id: watchRow
                width: parent.width
                height: parent.height/3

                Item {
                    height: width
                    width: parent.width/4
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        anchors.centerIn: parent
                        width: parent.width/2
                        antialiasing: true
                        fillMode: Image.PreserveAspectFit
                        source: Qt.resolvedUrl("../graphics/watch.png")
                    }
                }

                StatColumn {
                    id: watchStat1
                    category: "Episodes"
                }


                StatColumn {
                    id: watchStat2
                    category: "Shows"
                }

                StatColumn {
                    id: watchStat3
                    category: "Movies"
                }
            }

            Row {
                id: rateRow
                width: parent.width
                height: parent.height/3

                Item {
                    height: width
                    width: parent.width/4
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        anchors.centerIn: parent
                        width: parent.width/2
                        antialiasing: true
                        fillMode: Image.PreserveAspectFit
                        source: Qt.resolvedUrl("../graphics/heart.png")
                    }
                }

                StatColumn {
                    id: rateStat1
                    category: "Episodes"
                }


                StatColumn {
                    id: rateStat2
                    category: "Shows"
                }

                StatColumn {
                    id: rateStat3
                    category: "Movies"
                }
            }

            Row {
                id: collectionRow
                width: parent.width
                height: parent.height/3

                Item {
                    height: width
                    width: parent.width/4
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        anchors.centerIn: parent
                        width: parent.width/2
                        antialiasing: true
                        fillMode: Image.PreserveAspectFit
                        source: Qt.resolvedUrl("../graphics/collection_black.png")
                    }
                }

                StatColumn {
                    id: collectStat1
                    category: "Episodes"
                }


                StatColumn {
                    id: collectStat2
                    category: "Shows"
                }

                StatColumn {
                    id: collectStat3
                    category: "Movies"
                }
            }
        }
    }

    tools: ToolbarItems {
        id: toolbarUser

        locked: createAccountMessage.visible

        ToolbarButton {
            id: settings
            action: appSettingsAction
            visible: !account.visible
        }

        ToolbarButton {
            id: refresh
            action: refreshAccountAction
            visible: !account.visible
        }

        ToolbarButton {
            id: account
            action: setupAccountAction
            visible: createAccountMessage.visible
        }
    }
}

