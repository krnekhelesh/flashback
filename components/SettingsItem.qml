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
import Ubuntu.Components.ListItems 0.1 as ListItem

UbuntuShape {
    id: settingsItem

    // Property to set the contents of the settings item
    property alias contents: _contents.data

    // Property to set the header of the settings item
    property string title: "Default"

    radius: "medium"
    color: Qt.rgba(0,0,0,0.25)
    height: _titleContainer.height + _contentsContainer.height + units.gu(2)

    anchors {
        left: parent.left
        right: parent.right
    }

    Item {
        id: _titleContainer

        clip: true
        height: _title.height + units.gu(3)
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        UbuntuShape {
            id: _header
            radius: "medium"
            color: Qt.rgba(0,0,0,0.3)
            height: _title.height + units.gu(5)
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
        }
        
        Label {
            id: _title
            text: title
            font.pixelSize: units.dp(17)
            anchors {
                left: parent.left
                leftMargin: units.gu(2)
                top: parent.top
                topMargin: units.gu(1.5)
            }
        }
    }

    ListItem.ThinDivider {
        anchors.top: _titleContainer.bottom
    }

    Column {
        id: _contentsContainer

        anchors {
            bottomMargin: units.gu(1)
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        Column {
            id: _contents
            spacing: units.gu(1)
            width: parent.width
            clip: true
        }
    }
}
