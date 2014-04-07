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

// Walkthrough - Slide 7
Component {
    id: slide7
    Item {
        id: slide7Container
        
        UbuntuNumberAnimation on x {
            from: isForward ? width : -width; to: 0;
        }
        
        Label {
            id: introductionText
            fontSize: "x-large"
            text: "Ready!"
            anchors.top: parent.top
            anchors.topMargin: units.gu(5)
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Image {
            id: smileImage
            smooth: true
            width: units.gu(30)
            antialiasing: true
            fillMode: Image.PreserveAspectFit
            source: Qt.resolvedUrl("../graphics/smile.png")
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: units.gu(15)
            }
        }
        
        Label {
            id: finalMessage
            text: "We hope you enjoy using it! \n\n Flashback your movies and shows!"
            height: contentHeight
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: units.dp(20)
            horizontalAlignment: Text.AlignHCenter
            anchors {
                top: smileImage.bottom
                topMargin: units.gu(5)
                horizontalCenter: parent.horizontalCenter
            }
        }
        
        Button {
            id: continueButton
            color: "Green"
            height: units.gu(5)
            width: units.gu(25)
            text: "Start using Flashback!"
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: finalMessage.bottom
                topMargin: units.gu(5)
            }
            
            onClicked: {
                if(isFirstRun) {
                    firstRunDocument.contents = {
                        firstrun: "false"
                    }
                    pageStack.pop()
                    pageStack.push(rootComponent)
                }
                else {
                    while(pageStack.depth !== 2)
                        pageStack.pop()
                }
            }
        }
    }
}
