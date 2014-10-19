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

// Walkthrough - Slide 7
Component {
    id: slide7
    Item {
        id: slide7Container

        Column {
            id: mainColumn

            spacing: units.gu(4)
            anchors.fill: parent

            Label {
                id: introductionText
                fontSize: "x-large"
                font.bold: true
                text: "Ready!"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: smileImage
                height: parent.height - introductionText.height - finalMessage.contentHeight - 4.5*mainColumn.spacing
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../graphics/smile.png")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: finalMessage
                text: "We hope you enjoy using it!\n\nFlashback your movies and shows!"
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: units.dp(17)
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                id: continueButton
                color: "Green"
                height: units.gu(5)
                width: units.gu(25)
                text: "Start using Flashback!"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: finished()
            }
        }
    }
}
