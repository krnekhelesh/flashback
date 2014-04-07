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

// Walkthrough - Slide 5
Component {
    id: slide5
    Item {
        id: slide5Container
        
        UbuntuNumberAnimation on x {
            from: isForward ? width : -width; to: 0;
        }
        
        Label {
            id: introductionText
            fontSize: "x-large"
            text: "Flashback & Trakt"
            anchors.top: parent.top
            anchors.topMargin: units.gu(5)
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Image {
            id: centerImage
            width: parent.width/2
            fillMode: Image.PreserveAspectFit
            source: Qt.resolvedUrl("../graphics/fusion.png")
            anchors.top: introductionText.top
            anchors.topMargin: units.gu(8)
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Label {
            id: body
            text: "Flashback uses the Trakt web service to,\n\n1. Discover new shows & movies \n\n2. Rate, Review and Engage with Friends\n\n3. Personalised calendar of your favourite shows\n\n4. Track and share what you watch with Friends"
            font.pixelSize: units.dp(16)
            anchors {
                left: parent.left
                right: parent.right
                top: centerImage.bottom
                topMargin: units.gu(5)
                margins: units.gu(3)
            }
            wrapMode: Text.WordWrap
        }
    }
}
