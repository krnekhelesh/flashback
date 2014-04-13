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
        
        Column {
            id: mainColumn

            spacing: units.gu(4)
            anchors.fill: parent

            Label {
                id: introductionText
                font.bold: true
                fontSize: "x-large"
                text: "Flashback & Trakt"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: centerImage
                height: parent.height - introductionText.height - body.contentHeight - 4*mainColumn.spacing
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../graphics/fusion.png")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: body
                text: "Flashback uses the Trakt web service to,\n\n1. Discover new shows & movies \n2. Rate, Review and Engage with Friends\n3. Personalised calendar of your favourite shows\n4. Track and share what you watch with Friends"
                font.pixelSize: units.dp(17)
                anchors.horizontalCenter: parent.width <= units.gu(50) ? undefined : parent.horizontalCenter
                anchors.left: parent.width <= units.gu(50) ? parent.left : undefined
                anchors.right: parent.width <= units.gu(50) ? parent.right : undefined
                wrapMode: Text.WordWrap
            }
        }
    }
}
