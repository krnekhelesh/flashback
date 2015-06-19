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
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 1.0 as ListItem

/*
  The Detail Carousel is very similar to Carousel. It shows additional information such as Episode title,
  season and episode number and the release date. This carousel is primarily for displaying tv shows.
  */
Column {
    id: _detailCarousel

    // Header Title
    property alias header: _header.text

    // Carousel Data Model
    property alias dataModel: _carouselList.model

    // Carousel Thumbnail size (On the phone, show 2 + 2/3 cover art always by dynamically adjusting the size)
    property int size: parent.width < units.gu(50) ? (3 * (parent.width - 2*_carouselList.spacing))/8 : units.gu(17)

    // Property to show/hide date
    property bool showDate: true

    // Signal triggered when a thumb
    signal thumbClicked(var model)

    width: parent.width
    spacing: units.gu(1)
    visible: _carouselList.model.count > 0
    height: _header.height + _carouselList.height

    ListItem.Header {
        id: _header
        text: i18n.tr("Default Header Title")
    }

    ListView {
        id: _carouselList

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: units.gu(1)
        height: 1.5*_detailCarousel.size + units.gu(5)
        orientation: Qt.Horizontal
        spacing: units.gu(2)

        // Element consists of a Picture and a text label below it.
        delegate: Item {
            id: _carouselItem
            width: _detailCarousel.size
            height: _thumbColumn.height

            Column {
                id: _thumbColumn
                spacing: units.gu(0.5)

                // Widget to curve edges and encase the thumbnail
                Thumbnail {
                    id: _carouselThumb
                    radius: "medium"
                    width: _detailCarousel.size
                    height: 1.5*_detailCarousel.size
                    thumbSource: thumb_url

                    Item {
                        id: bottomContainer
                        clip: true
                        height: parent.height/5
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }

                        UbuntuShape {
                            id: detailsContainer
                            height: _carouselThumb.height
                            anchors {
                                bottom: parent.bottom
                                left: parent.left
                                right: parent.right
                            }
                            radius: "medium"
                            color: Qt.rgba(0,0,0,0.8)
                        }

                        Column {
                            id: detailsColumn
                            anchors {
                                left: parent.left
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                                margins: units.gu(1)
                            }

                            // Label showing the tv episode name
                            Label {
                                id: _episodeTitle
                                text: episode_name
                                elide: Text.ElideRight
                                font.bold: true
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                            }

                            // Container to hold the tv show season number and release date
                            Item {
                                height: childrenRect.height
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }

                                Label {
                                    id: _seasonDetail
                                    text: "S" + season + "E" + episode
                                    width: parent.width * (2/5)
                                    elide: Text.ElideRight
                                    fontSize: "small"
                                    anchors.left: parent.left
                                }

                                Label {
                                    id: _seasonDate

                                    font.bold: true
                                    fontSize: "small"
                                    color: "LightGreen"
                                    visible: showDate
                                    text: get_date(episode_air_date)
                                    elide: Text.ElideRight
                                    width: parent.width * (3/5)
                                    anchors.right: parent.right
                                    horizontalAlignment: Text.AlignRight

                                    function get_date(iso) {
                                        var date, month
                                        date = iso.split('T')[0].split('-')
                                        month = Qt.locale().standaloneMonthName(date[1] - 1, Locale.ShortFormat)
                                        return date[2] + " " + month
                                    }
                                }
                            }
                        }
                    }
                }

                // Label showing the tv show name
                Label {
                    id: _carouselThumbDescription
                    text: name
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    width: _carouselThumb.width
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: _detailCarousel.thumbClicked(model)
            }
        }
    }
}

