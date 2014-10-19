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
import QtGraphicalEffects 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {
    id: userTab

    flickable: null

    Component.onCompleted: console.log("[LOG]: TV Tab Loaded")

    Action {
        id: appSettingsAction
        text: i18n.tr("Settings")
        visible: !createAccountMessage.visible
        keywords: i18n.tr("Settings;Setting;Configuration;Account;Authenticate")
        description: i18n.tr("Application Settings")
        iconName: "settings"
        onTriggered: pagestack.push(Qt.resolvedUrl("SettingPage.qml"))
    }

    Action {
        id: setupAccountAction
        text: i18n.tr("Account")
        visible: createAccountMessage.visible
        keywords: i18n.tr("Setup;Create;Account;Trakt")
        description: i18n.tr("Setup a Trakt Account")
        iconName: "add"
        onTriggered: pageStack.push(Qt.resolvedUrl("Trakt.qml"))
    }

    Action {
        id: refreshAccountAction
        text: i18n.tr("Refresh")
        visible: !account.visible
        keywords: i18n.tr("Reload;Refresh;New;Trakt")
        description: i18n.tr("Refresh Account Information")
        iconName: "reload"
        onTriggered: traktAccountModel.fetchData(traktLogin.contents.username, traktLogin.contents.password)
    }

    head.actions: [
        appSettingsAction,
        refreshAccountAction,
        setupAccountAction
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
                stat1.value = reply.stats.friends
                stat2.value = reply.stats.episodes.checkins + reply.stats.movies.checkins

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
                stat1.value = stat2.value = "?"
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

    Image {
        id: arrow
        source: Qt.resolvedUrl("../graphics/arrow.png")
        width: units.gu(8)
        height: width
        smooth: true
        visible: createAccountMessage.visible
        transform: Rotation {
            axis { x: 0; y: 0; z: 1 }
            angle: -90
        }
        anchors {
            right: parent.right
            top: parent.top
            topMargin: units.gu(10)
            rightMargin: units.gu(-1.5)
        }

        SequentialAnimation on anchors.topMargin {
            running: createAccountMessage.visible
            loops: 5
            NumberAnimation { from: units.gu(10); to: units.gu(13); duration: 1000 }
            PauseAnimation { duration: 250 }
            NumberAnimation { from: units.gu(13); to: units.gu(10); duration: 1000 }
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
                title: i18n.tr("Profile Details")
                icon: Qt.resolvedUrl("../graphics/user_white.png")
                visible: traktLogin.contents.status !== "disabled"
                contents: [
                    Row {
                        id: profileRow
                        spacing: units.gu(1)
                        height: _profilePicture.height
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: units.gu(2)
                        }

                        Thumbnail {
                            id: _profilePicture
                            width: height
                            height: 0.15 * userTab.height
                        }

                        Column {
                            id: profileFieldColumn
                            anchors.verticalCenter: _profilePicture.verticalCenter
                            Label {
                                id: field1
                                font.bold: true
                                fontSize: "large"
                            }

                            Label {
                                id: field2
                                width: profileRow.width - _profilePicture.width - units.gu(2)
                                elide: Text.ElideRight
                                MouseArea {
                                    enabled: field2.text.indexOf("http://") > -1 ? true : false
                                    anchors.fill: parent
                                    onClicked: Qt.openUrlExternally(field2.text)
                                }
                            }
                        }
                    },

                    ListItem.ThinDivider {},

                    ListItem.Empty {
                        height: statRow.height
                        showDivider: false

                        Row {
                            id: statRow
                            width: parent.width
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: stat1.height

                            StatColumn {
                                id: stat1
                                width: parent.width/2
                                category: "Friends"
                            }

                            StatColumn {
                                id: stat2
                                width: parent.width/2
                                category: "Check-ins"
                            }
                        }
                    }
                ]
            }

            SettingsItem {
                title: i18n.tr("Watched")
                icon: Qt.resolvedUrl("../graphics/watched.png")
                visible: traktLogin.contents.status !== "disabled"
                contents: [
                    Row {
                        id: watchRow
                        width: parent.width
                        height: watchStat1.height

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
                ]
            }

            SettingsItem {
                title: i18n.tr("Rated")
                icon: Qt.resolvedUrl("../graphics/heart-0.png")
                visible: traktLogin.contents.status !== "disabled"
                contents: [
                    Row {
                        id: rateRow
                        width: parent.width
                        height: rateStat1.height

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
                ]
            }

            SettingsItem {
                title: i18n.tr("Collected")
                icon: Qt.resolvedUrl("../graphics/collection_white.png")
                visible: traktLogin.contents.status !== "disabled"
                contents: [
                    Row {
                        id: collectionRow
                        width: parent.width
                        height: collectStat1.height

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
                ]
            }
        }
    }
}

