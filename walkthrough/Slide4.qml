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

// Walkthrough - Slide 4
Component {
    id: slide4
    Item {
        id: slide4Container
        
        Column {
            id: mainColumn

            spacing: units.gu(4)
            anchors.fill: parent

            Label {
                id: introductionText
                font.bold: true
                fontSize: "x-large"
                text: "Watchlist"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: centerImage
                height: parent.height - introductionText.height - body.contentHeight - 4*mainColumn.spacing
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../graphics/bookmark.png")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: body
                text: "No time to watch the movie you heard from your friends? Add it to your watchlist to watch later. \n\nLet Flashback handle all the bookkeeping while you enjoy the content."
                font.pixelSize: units.dp(17)
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
