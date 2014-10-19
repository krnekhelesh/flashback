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

Column {
    id: _emptyState

    // Property to set the image of the empty state
    property alias logo: _emptyLogo.source

    // Property to set the header of the empty state
    property alias header: _emptyStateHeader.text

    // Property to set the message of the empty state
    property alias message: _emptyStateMessage.text

    anchors {
        left: parent.left
        right: parent.right
        margins: units.gu(2)
        verticalCenter: parent.verticalCenter
    }

    spacing: units.gu(4)

    Image {
        id: _emptyLogo
        visible: source !== ""
        width: parent.width/3
        antialiasing: true
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Column {
        id: _messageColumn
        width: parent.width

        Label {
            id: _emptyStateHeader
            font.bold: true
            width: parent.width
            fontSize: "x-large"
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            id: _emptyStateMessage
            width: parent.width
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
