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
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

/*
  The carousel is an element which displays a header title with a flickable row of ubuntu shape thumbnails.
  */
Column {
    id: carousel

    // Header Title
    property alias header: header.text

    // Carousel Data Model
    property alias dataModel: carouselList.model

    // Carousel Thumbnail size (On the phone, show 2 + 2/3 cover art always by dynamically adjusting the size)
    property real size: parent.width < units.gu(50) ? (3 * (parent.width - 2*carouselList.spacing))/8 : units.gu(17)

    // Property to hold the watched status
    property bool showTraktUserStatus: false

    // Signal triggered when a thumb
    signal thumbClicked(var model)

    width: parent.width
    spacing: units.gu(1)
    visible: carouselList.model.count > 0
    height: header.height + carouselList.height

    ListItem.Header {
        id: header
        text: i18n.tr("Default Header Title")
    }

    ListView {
        id: carouselList

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: units.gu(1)
        height: 1.5*carousel.size + units.gu(5)
        orientation: Qt.Horizontal
        spacing: units.gu(2)

        // Element consists of a Picture and a text label below it.
        delegate: Item {
            id: thumbContainer

            width: carousel.size
            height: thumbColumn.height

            StatusIcons {
                id: traktStatusContainer

                showWatchedIcon: traktStatusContainer.visible ? watched ? (watched === "true" ? true : false) : false : false
                showWatchListIcon: traktStatusContainer.visible ? watchlist ? (watchlist === "true" ? true : false) : false : false
                visible: carousel.showTraktUserStatus

                anchors {
                    top: parent.top
                    left: parent.left
                }
            }

            Column {
                id: thumbColumn
                spacing: units.gu(0.5)

                // Widget to curve edges and encase the thumbnail
                Thumbnail {
                    id: carouselThumb
                    width: carousel.size
                    height: 1.5*carousel.size
                    thumbSource: thumb_url
                }

                // Label showing the movie/tv show name
                Label {
                    id: carouselThumbDescription

                    text: name
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    width: carouselThumb.width
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: carousel.thumbClicked(model)
            }
        }
    }
}

