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

// Walkthrough - Slide 6
Component {
    id: slide6
    Item {
        id: slide6Container
        
        UbuntuNumberAnimation on x {
            from: isForward ? width : -width; to: 0;
        }
        
        UbuntuShape {
            id: logo
            anchors {
                top: parent.top
                topMargin: units.gu(5)
                horizontalCenter: parent.horizontalCenter
            }
            
            image: Image {
                smooth: true
                antialiasing: true
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../flashback.png")
            }
        }
        
        Column {
            id: textColumn
            
            spacing: units.gu(6)
            anchors {
                top: logo.bottom
                topMargin: units.gu(5)
                left: parent.left
                right: parent.right
                margins: units.gu(4)
            }
            
            Label {
                text: "Flashback"
                height: contentHeight
                font.pixelSize: units.dp(50)
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "Your personal assistant is almost ready! To get started log in or sign up to Trakt\n\nYou can also swipe ahead without a Trakt account. However you will miss out on certain features."
                height: contentHeight
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: units.dp(16)
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Row {
                id: buttonRow
                spacing: units.gu(2)
                anchors.horizontalCenter: parent.horizontalCenter
                
                Button {
                    height: units.gu(5)
                    width: traktLogin.contents.status === "disabled" ? units.gu(18) : units.gu(25)
                    text: traktLogin.contents.status === "disabled" ? i18n.tr("Log in") : i18n.tr("Successfully Logged in!")
                    color: "Green"
                    onClicked: traktLogin.contents.status === "disabled" ? pagestack.push(Qt.resolvedUrl("../ui/TraktLogin.qml"), {"isLogin": true}) : undefined
                    onTextChanged: {
                        if(traktLogin.contents.status !== "disabled" && text === i18n.tr("Log in")) {
                            console.log("change")
                            walkthrough.state = "Slide " + (currentSlide+1)
                        }
                    }
                }
                
                Button {
                    color: "Orange"
                    height: units.gu(5)
                    width: units.gu(18)
                    text: i18n.tr("Sign up with email")
                    visible: traktLogin.contents.status === "disabled"
                    onClicked: pagestack.push(Qt.resolvedUrl("../ui/TraktLogin.qml"), {"isLogin": false})
                }
                
            }
        }
    }
}
