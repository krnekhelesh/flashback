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

Item {
    id: grid

    // Header Title
    property alias header: header.text

    // Grid Data Model
    property alias dataModel: gridView.model

    // Grid Thumbnail size
    property int size: units.gu(12)

    // Signal triggered when a thumb
    signal thumbClicked(var model)

    width: parent.width
    visible: gridView.model.count > 0

    Column {
        id: container

        anchors.fill: parent
        spacing: units.gu(1)

        Header {
            id: header
            text: i18n.tr("Default Header Title")
            visible: text != i18n.tr("Default Header Title")
        }

        Component {
            id: gridDelegate
            Item {
                id: thumbContainer

                width: grid.size + units.gu(2)
                height: thumbColumn.height

                Column {
                    id: thumbColumn
                    spacing: units.gu(0.5)
                    anchors.fill: parent

                    // Widget to curve edges and encase the thumbnail
                    Thumbnail {
                        id: gridThumb
                        width: grid.size
                        height: grid.size + units.gu(5)
                        thumbSource: thumb_url

                        MouseArea {
                            anchors.fill: parent
                            onClicked: grid.thumbClicked(model)
                        }
                    }

                    // Label showing the movie/tv show name
                    Label {
                        id: gridThumbDescription

                        text: name
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                        width: gridThumb.width
                        horizontalAlignment: Text.AlignHCenter

                        MouseArea {
                            anchors.fill: parent
                            onClicked: grid.thumbClicked(model)
                        }
                    }
                }
            }
        }


        GridView {
            id: gridView

            clip: true
            width: parent.width
            height: header.visible ? parent.height - header.height - parent.spacing : parent.height - parent.spacing
            snapMode: GridView.SnapToRow

            cellHeight: grid.size + units.gu(12)
            cellWidth: grid.size + container.spacing

            delegate: gridDelegate
        }

    }
}
