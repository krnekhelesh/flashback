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

// Slide 1
Component {
    id: slide1
    Item {
        id: slide1Container

        UbuntuShape {
            anchors {
                bottom: textColumn.top
                bottomMargin: units.gu(4)
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

            anchors.centerIn: parent

            Label {
                text: "Welcome to"
                fontSize: "x-large"
                height: contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: appName
                font.bold: true
                height: contentHeight
                font.pixelSize: units.dp(50)
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Label {
            id: swipeText
            text: "Swipe left to continue"
            horizontalAlignment: Text.AlignHCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: units.gu(2)
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
