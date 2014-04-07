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

// Walkthrough - Slide 2
Component {
    id: slide2
    Item {
        id: slide2Container
        
        UbuntuNumberAnimation on x {
            from: isForward ? width : -width; to: 0;
        }
        
        Label {
            id: introductionText
            text: "Flashback"
            fontSize: "x-large"
            anchors.top: parent.top
            anchors.topMargin: units.gu(5)
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Column {
            id: mainColumn
            spacing: units.gu(1)
            anchors {
                top: introductionText.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: units.gu(4)
            }
            
            Label {
                id: bodyText
                wrapMode: Text.WordWrap
                anchors.left: parent.left
                anchors.right: parent.right
                font.pixelSize: units.dp(17)
                horizontalAlignment: Text.AlignHCenter
                text: "Flashback is an entertainment app that helps you discover new movies and shows. It learns about your tastes over time and provides you with personalised recommendations.\n\nYour very own personal assistant!"
            }
            
            Image {
                id: centerImage
                width: 1.3 * parent.width
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                source: Qt.resolvedUrl("../graphics/centerImage.png")
            }
        }
    }
}
