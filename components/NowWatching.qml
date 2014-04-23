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
import Ubuntu.Components.ListItems 0.1

Column {
    id: nowWatching

    spacing: units.gu(1)

    // Public properties to set the currently watched movie/tv
    property alias backgroundFanArt: _backgroundFanArt.thumbSource
    property alias posterArt: _poster.thumbSource
    property alias title: _title.text
    property alias subtitle: _subtitle.text
    property alias extra: _extra.text
    property bool showTrailer: false

    // Signal triggered when a thumb is clicked
    signal thumbClicked()

    // Signal triggered when trailer is clicked
    signal trailerClicked()

    // Default width and height
    property int backgroundWidth: units.gu(35)
    property int backgroundHeight: units.gu(20)

    Header { text: i18n.tr("Now Watching") }

    DesaturatedThumbnail {
        id: _backgroundFanArt

        width: backgroundWidth
        height: backgroundHeight

        anchors.left: parent.left
        anchors.leftMargin: units.gu(1)

        Thumbnail {
            id: _poster
            width: parent.width/3.3
            z: parent.z + 1
            visible: !_backgroundFanArt.ready
            anchors {
                left: parent.left
                top: parent.top
                bottom: _detailsContainer.top
                margins: units.gu(0.5)
            }
        }

        // Container to show more details like episode title or movie runtime etc
        Rectangle {
            id: _detailsContainer

            color: "Black"
            opacity: 0.7
            z: parent.z + 1
            radius: units.gu(1)
            height: parent.height/5
            visible: !_backgroundFanArt.ready
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Label {
                id: _subtitle
                elide: Text.ElideRight
                width: parent.width * (4/5)
                anchors {
                    leftMargin: units.gu(1)
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }

            Label {
                id: _extra
                width: parent.width/5
                elide: Text.ElideRight
                visible: !nowWatching.showTrailer
                horizontalAlignment: Text.AlignRight
                anchors {
                    rightMargin: units.gu(1)
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }

            Image {
                id: _trailer

                width: units.gu(3)
                height: width
                visible: nowWatching.showTrailer
                source: Qt.resolvedUrl("../graphics/trailer.png")
                anchors {
                    rightMargin: units.gu(1)
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true
                    enabled: _trailer.visible
                    onClicked: nowWatching.trailerClicked()
                }
            }
        }

        MouseArea {
            id: thumbArea
            anchors.fill: parent
            onClicked: nowWatching.thumbClicked()
        }
    }

    Label {
        id: _title
        maximumLineCount: 2
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        anchors {
            left: _backgroundFanArt.left
            right: _backgroundFanArt.right
        }
    }
}
