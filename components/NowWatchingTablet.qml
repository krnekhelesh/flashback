/*
 * Flashback - Entertainment app for Ubuntu
 * Copyright (C) 2014 Nekhelesh Ramananthan <nik90@ubuntu.com>
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
    id: nowWatchingTablet

    // Public properties to set the currently watched movie/tv in tablet form factor
    property alias backgroundFanArt: _backgroundArt.source
    property alias posterArt: _posterArt.thumbSource
    property alias title: _title.text
    property alias subtitle: _subtitle.text
    property alias extra: _extra.text

    // Signal triggered when a thumb is clicked
    signal thumbClicked()

    width: parent.width
    height: units.gu(15)

    // Black overlay rectangle over fan art
    Rectangle {
        anchors.fill: parent
        color: "Black"
        opacity: 0.7
    }

    // Background Image
    Image {
        id: _backgroundArt
        z: parent.z - 1
        width: parent.width
        fillMode: Image.PreserveAspectFit
    }
    
    ListItem.Header {
        text: i18n.tr("Now Watching")
        anchors.bottom: _backgroundArt.top
    }
    
    Thumbnail {
        id: _posterArt
        width: units.gu(10)
        height: units.gu(13)
        anchors.left: parent.left
        anchors.leftMargin: units.gu(1)
        anchors.verticalCenter: parent.verticalCenter
    }
    
    Column {
        anchors {
            margins: units.gu(1)
            verticalCenter: _posterArt.verticalCenter
            left: _posterArt.right
            right: parent.right
        }
        
        Label {
            id: _title
            font.bold: true
            fontSize: "large"
            width: parent.width
            maximumLineCount: 2
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
        
        Label {
            id: _subtitle
            width: parent.width
            elide: Text.ElideRight
        }
        
        Label {
            id: _extra
            width: parent.width
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: thumbArea
        anchors.fill: parent
        onClicked: nowWatchingTablet.thumbClicked()
    }
}
