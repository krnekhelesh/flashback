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
import Ubuntu.Components 0.1

// Walkthrough - Slide 6
Component {
    id: slide6
    Item {
        id: slide6Container

        Column {
            id: textColumn
            
            spacing: units.gu(6)
            anchors.fill: parent

            Label {
                id: introductionText
                text: "Trakt Account"
                height: contentHeight
                font.bold: true
                fontSize: "x-large"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: centerImage
                height: parent.height - introductionText.height - body.contentHeight - 4*textColumn.spacing
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../graphics/account.png")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: body
                text: "Your personal assistant is almost ready! To get started log in or sign up to Trakt\n\nYou can also swipe ahead without a Trakt account. However you will miss out on certain features."
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: units.dp(17)
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Row {
                id: buttonRow

                height: units.gu(5)
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
