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

Item {
    id: grid

    // Property to choose the grid type
    property string gridType: "gridCarousel"

    // Header Title
    property alias header: header.text

    // Grid Data Model
    property alias dataModel: gridView.model

    // Property to show/hide date
    property bool showDate: true

    // Grid Thumbnail size
    property int size: {
        if (width >= units.gu(170))
            return (width - 9*container.spacing)/8
        if (width >= units.gu(150))
            return (width - 8*container.spacing)/7
        else if (width >= units.gu(130))
            return (width - 7*container.spacing)/6
        else if (tabletLandscapeForm || width > units.gu(100))
            return (width - 6*container.spacing)/5
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

        ListItem.Header {
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
                        radius: "small"
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

        Component {
            id: gridDetailedCarouselDelegate
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
                        radius: "small"
                        width: grid.size
                        height: grid.gridHeight
                        thumbSource: thumb_url

                        MouseArea {
                            anchors.fill: parent
                            onClicked: grid.thumbClicked(model)
                        }

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
                                height: gridThumb.height
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
                        id: gridThumbDescription
                        text: name
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                        width: gridThumb.width
                        horizontalAlignment: Text.AlignHCenter
                        visible: !tabletPortraitForm && !tabletLandscapeForm

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

            cellHeight: !tabletPortraitForm && !tabletLandscapeForm ? grid.gridHeight + units.gu(5)
                                                                    : gridType == "gridCarousel" ? grid.gridHeight + units.gu(8)
                                                                                                 : grid.gridHeight + units.gu(2)
            cellWidth: grid.size + container.spacing

            delegate: gridType == "gridCarousel" ? gridCarouselDelegate : gridDetailedCarouselDelegate
        }
    }
}
