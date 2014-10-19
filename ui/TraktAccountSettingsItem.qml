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
import "../components"
import "../models"

SettingsItem {
    id: traktAccountSetting

    title: "Trakt Account"
    
    // Function to logout of the trakt user account
    function logout() {
        traktLogin.contents = {
            username: "johnDoe",
            password: "password",
            status: "disabled"
        }
    }
    
    TraktAccountSettings {
        id: traktAccountModel
        username: traktLogin.contents.username
        password: traktLogin.contents.password
        onPasswordChanged: {
            console.log("[LOG]: Retrieving trakt account details")
            fetchData(username, password)
        }
        function updateJSONModel() {
            if(traktLogin.contents.status !== "disabled") {
                primaryDetail.text = reply.profile.full_name ? reply.profile.full_name : reply.profile.username
                secondaryDetail.text= reply.profile.location ? reply.profile.location : "Authenticated into Trakt"
                profileImage.thumbSource = reply.profile.avatar
            }
            else {
                primaryDetail.text = "JohnDoe"
                secondaryDetail.text = "Linux"
                profileImage.thumbSource = Qt.resolvedUrl("../graphics/no-passport.png")
            }
        }
    }
    
    contents: [
        ListItem.Base {
            id: accountDetails
            
            progression: true
            showDivider: false
            height: profileImage.height + units.gu(1)
            visible: traktLogin.contents.status !== "disabled"
            onClicked: pagestack.push(Qt.resolvedUrl("Trakt.qml"))
            
            Row {
                id: detailsRow
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                
                spacing: units.gu(2)
                
                Thumbnail {
                    id: profileImage
                    width: units.gu(10)
                    height: width
                }
                
                Column {
                    id: profileDetail

                    anchors.verticalCenter: profileImage.verticalCenter
                    
                    Label {
                        id: primaryDetail
                        fontSize: "large"
                        elide: Text.ElideRight
                        width: detailsRow.width - profileImage.width - units.gu(2)
                    }
                    
                    Label {
                        id: secondaryDetail
                        width: primaryDetail.width
                        elide: Text.ElideRight
                    }
                }
            }
        },
        
        ListItem.Base {
            progression: true
            showDivider: false
            onClicked: pagestack.push(Qt.resolvedUrl("Trakt.qml"))
            height: traktDescription.contentHeight
            visible: traktLogin.contents.status === "disabled"
            
            Label {
                id: traktDescription
                anchors .left: parent.left
                anchors.right: parent.right
                wrapMode: Text.WordWrap
                text: i18n.tr("Trakt is a platform that does many things, but primarily keeps track of TV shows and movies you watch. It integrates with your media center or home theater PC to enable scrobbling, so everything is automatic.
                                \nClick here for more details...")
            }
        },
        
        ListItem.ThinDivider {},
        
        Row {
            id: traktActionRow

            height: units.gu(4)
            spacing: units.gu(2)
            visible: traktLogin.contents.status === "disabled"
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                text: "Log into Trakt"
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: pagestack.push(Qt.resolvedUrl("TraktLogin.qml"), {"isLogin": true})
                }
            }
            
            Label {
                text: "|"
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Label {
                text: "Sign up to Trakt"
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: pagestack.push(Qt.resolvedUrl("TraktLogin.qml"), {"isLogin": false})
                }
            }
        },
        
        Label {
            height: units.gu(4)
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Sign out of this account")
            visible: traktLogin.contents.status !== "disabled"
            MouseArea {
                anchors.fill: parent
                onClicked: logout()
            }
        }
    ]
}
