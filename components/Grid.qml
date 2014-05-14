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
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0

Item {
    id: grid

    // Header Title
    property alias header: header.text

    // Grid Data Model
    property alias dataModel: gridView.model

    // Grid Thumbnail size
    property int size: {
        if (width >= units.gu(170))
            return (width - 9*container.spacing)/8
        if (width >= units.gu(150))
            return (width - 8*container.spacing)/7
        else if (width >= units.gu(130))
            return (width - 7*container.spacing)/6
        else if (width > units.gu(80))
            return (width - 5*container.spacing)/4
        else if (width >= units.gu(60))
            return (width - 4*container.spacing)/3
        else
            return (width - 3*container.spacing)/2
    }

    // Grid Thumbnail height
    property int gridHeight: 1.5*size

    // Signal triggered when a thumb
    signal thumbClicked(var model)

    width: parent.width
    visible: gridView.model.count > 0

    Column {
        id: container

        spacing: units.gu(3)
        anchors {
            fill: parent
            leftMargin: units.gu(3)
        }

        Header {
            id: header
            text: i18n.tr("Default Header Title")
            visible: text !== i18n.tr("Default Header Title")
            anchors {
                left: parent.left
                right: parent.right
                margins: -units.gu(3)
            }
        }

        Component {
            id: gridCarouselDelegate
            Item {
                id: thumbContainer

                width: grid.size
                height: grid.gridHeight + units.gu(5)

                Column {
                    id: thumbColumn
                    spacing: units.gu(0.5)
                    anchors.fill: parent

                    // Widget to curve edges and encase the thumbnail
                    Thumbnail {
                        id: gridThumb
                        radius: "medium"
                        width: grid.size
                        height: grid.gridHeight
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
                        visible: true
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
            height: header.visible ? parent.height - header.height - parent.spacing : parent.height
            snapMode: GridView.SnapToRow

            cellHeight: grid.gridHeight + units.gu(5)
            cellWidth: grid.size + container.spacing

            delegate: gridCarouselDelegate
        }

    }
}
