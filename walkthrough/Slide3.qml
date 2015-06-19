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

import QtQuick 2.4
import Ubuntu.Components 0.1

// Walkthrough - Slide 3
Component {
    id: slide3
    Item {
        id: slide3Container
        
        Column {
            id: mainColumn

            spacing: units.gu(4)
            anchors.fill: parent

            Label {
                id: introductionText
                font.bold: true
                fontSize: "x-large"
                text: "Check-In"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: centerImage
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../graphics/share.png")
                height: parent.height - introductionText.height - body.contentHeight - 4*mainColumn.spacing
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: body
                text: "Checking-in movies & shows just before you watch them adds them to your history and allows for a personalised recommendation list. \n\nYou can also choose to share what you check-in to facebook, twitter and tumblr."
                font.pixelSize: units.dp(17)
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
